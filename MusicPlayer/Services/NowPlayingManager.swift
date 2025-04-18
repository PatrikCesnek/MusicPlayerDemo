//
//  NowPlayingManager.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 18/04/2025.
//

import Foundation
import MediaPlayer

enum NowPlayingManager {
    
    static func setup(with song: Song, isPlaying: Bool, currentTime: Double, duration: Double) {
        let info: [String: Any] = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        
        if let artworkURL = song.artworkURL {
            Task {
                await setArtwork(from: artworkURL)
            }
        }
    }

    static func update(title: String, artist: String, currentTime: Double, duration: Double, isPlaying: Bool) {
        var info: [String: Any] = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]

        info[MPMediaItemPropertyTitle] = title
        info[MPMediaItemPropertyArtist] = artist
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        info[MPMediaItemPropertyPlaybackDuration] = duration
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    static func setArtwork(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return }

            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }

            var info = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
            info[MPMediaItemPropertyArtwork] = artwork
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        } catch {
            print("Artwork load failed: \(error)")
        }
    }
}
