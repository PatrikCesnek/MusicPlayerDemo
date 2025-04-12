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
    var isPlaying = false
    var currentTime: Double = 0
    var duration: Double = 0
    var isLoading = false
    
    private var timeObserver: Any?
    
    func play(url: URL) {
        isLoading = true
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        addPeriodicTimeObserver()

        player?.play()
        isPlaying = true
        isLoading = false

        Task {
            do {
                let duration = try await playerItem.asset.load(.duration)
                let seconds = duration.seconds
                if seconds.isFinite {
                    await MainActor.run {
                        self.duration = seconds
                    }
                }
            } catch {
                print("Failed to load duration: \(error)")
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
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 600))
        currentTime = time
    }
    
    private func addPeriodicTimeObserver() {
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(
                seconds: 1,
                preferredTimescale: 600
            ),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
    
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}

