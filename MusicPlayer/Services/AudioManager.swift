//
//  AudioManager.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation
import AVFoundation

@Observable
class AudioManager {
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    var isPlaying = false
    var currentTime: Double = 0
    var duration: Double = 0
    var isLoading = false
    
    private var timeObserver: Any?

    func load(url: URL) {
        guard player == nil else { return }

        isLoading = true
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
                print("Failed to load duration: \(error)")
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
        if isPlaying {
            player.play()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}
