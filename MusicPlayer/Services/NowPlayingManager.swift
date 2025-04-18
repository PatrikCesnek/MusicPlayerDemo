//
//  NowPlayingManager.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 18/04/2025.
//

import Foundation
import MediaPlayer
import UIKit

struct NowPlayingManager {
    static func setup(with song: Song, isPlaying: Bool, currentTime: Double, duration: Double) {
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
                    print(Constants.Strings.playbackError + " \(error.localizedDescription)")
                }
            }

            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }

    static func update(title: String, artist: String, currentTime: Double, duration: Double, isPlaying: Bool) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
