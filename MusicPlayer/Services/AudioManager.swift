//
//  AudioManager.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation
import AVFoundation
import MediaPlayer

@Observable
class AudioManager {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    var isPlaying = false
    var currentTime: Double = 0
    var duration: Double = 0
    var isLoading = false
    var error: String?
    
    var currentFileName: String?
    var currentSong: Song?

    private var timeObserver: Any?
    
    static let shared = AudioManager()
    private init() {
        configureAudioSession()
    }

    func loadAndPlay(url: URL, fileName: String, song: Song, forceStream: Bool = false) async throws {
        if currentFileName != fileName || player == nil {
            isLoading = true
            
            let playURL: URL
            
            if !forceStream, let localURL = FileDownloadManager.shared.localFileURL(named: fileName) {
                playURL = localURL
            } else {
                playURL = url
            }

            await MainActor.run {
                self.preparePlayer(with: playURL)
                self.currentFileName = fileName
                self.player?.play()
                self.isPlaying = true
                self.setupNowPlaying(song: song)
            }
        } else {
            player?.play()
            isPlaying = true
            setupNowPlaying(song: song)
        }
    }

    private func preparePlayer(with url: URL) {
        stop()
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        addPeriodicTimeObserver()
        addPlaybackFinishedObserver()

        Task {
            do {
                let duration = try await playerItem?.asset.load(.duration)
                let seconds = duration?.seconds ?? 0
                if seconds.isFinite {
                    await MainActor.run {
                        self.duration = seconds
                    }
                }
            } catch {
                self.error = Constants.Strings.durationError + " \(error.localizedDescription)"
            }

            await MainActor.run {
                self.isLoading = false
            }
        }
    }

    func togglePlayPause() {
        guard let player = player else { return }

        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }

    func seek(to time: Double) {
        guard let player = player else { return }

        player.seek(to: CMTime(seconds: time, preferredTimescale: 600))
        currentTime = time
    }

    private func addPeriodicTimeObserver() {
        guard let player = player else { return }

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self = self else { return }

            self.currentTime = time.seconds

            if let song = self.currentSong {
                self.updateNowPlayingInfo(
                    title: song.title,
                    artist: song.artist,
                    duration: self.duration,
                    currentTime: self.currentTime
                )
            }
        }
    }


    private func addPlaybackFinishedObserver() {
        guard let item = playerItem else { return }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlaybackEnded),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )
    }

    @objc private func handlePlaybackEnded() {
        isPlaying = false
        currentTime = duration
    }
    
    func restart() {
        guard let player = player else { return }

        player.seek(to: .zero)
        currentTime = 0
        if !isPlaying {
            player.play()
            isPlaying = true
        }
    }
    
    func playNextSongAsync(from url: URL, fileName: String, song: Song) async throws {
        if currentFileName != fileName {
            stop()
            player = nil
            playerItem = nil
            currentTime = 0
            duration = 0
            isPlaying = false
        }

        try await loadAndPlay(url: url, fileName: fileName, song: song)
    }

    func stop() {
        player?.pause()
        isPlaying = false
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(
                .playback,
                mode: .default,
                policy: .longFormAudio,
                options: []
            )
            try session.setActive(true)
        } catch {
            self.error = "Failed to configure AVAudioSession: \(error.localizedDescription)"
        }
    }
    
    func setupNowPlaying(song: Song) {
        Task {
            var nowPlayingInfo: [String: Any] = [
                MPMediaItemPropertyTitle: song.title,
                MPMediaItemPropertyArtist: song.artist,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
                MPMediaItemPropertyPlaybackDuration: duration,
                MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
            ]

            if let artworkURL = song.artworkURL {
                do {
                    let (data, _) = try await URLSession.shared.data(from: artworkURL)
                    if let image = UIImage(data: data) {
                        let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                    }
                } catch {
                    print("Failed to load artwork: \(error)")
                }
            }

            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    func configureRemoteCommands(togglePlayPause: @escaping () -> Void) {
        let center = MPRemoteCommandCenter.shared()
        
        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
        center.nextTrackCommand.isEnabled = false
        center.previousTrackCommand.isEnabled = false
        
        center.playCommand.addTarget { [weak self] _ in
            self?.player?.play()
            self?.isPlaying = true
            return .success
        }
        
        center.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause()
            self?.isPlaying = false
            return .success
        }
    }
    
    func updateNowPlayingInfo(title: String, artist: String, duration: Double, currentTime: Double) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    deinit {
        stop()
    }
}
