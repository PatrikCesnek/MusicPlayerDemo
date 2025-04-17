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

    private var timeObserver: Any?
    
    static let shared = AudioManager()
    private init() {
        configureAudioSession()
    }

    func loadAndPlay(url: URL, fileName: String, forceStream: Bool = false) async throws {
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
            }
        } else {
            player?.play()
            isPlaying = true
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
            self?.currentTime = time.seconds
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
    
    func playNextSongAsync(from url: URL, fileName: String) async throws {
        if currentFileName != fileName {
            stop()
            player = nil
            playerItem = nil
            currentTime = 0
            duration = 0
            isPlaying = false
        }
        
        try await loadAndPlay(url: url, fileName: fileName)
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
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            self.error = "Failed to configure AVAudioSession: \(error.localizedDescription)"
        }
    }
    
    func setupNowPlaying(song: Song) {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]

        if let artworkURL = song.artworkURL,
           let data = try? Data(contentsOf: artworkURL),
           let image = UIImage(data: data) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
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

    deinit {
        stop()
    }
}
