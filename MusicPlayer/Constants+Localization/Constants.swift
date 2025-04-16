//
//  Constants.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation

struct Constants {
    struct Strings {
        static let songListURL = "https://harmanec.com/hh-assignment/tracks.json"
        static let lastPlayedPositionKey = "lastPlaybackPosition"
        static let lastPlayedSongKey = "lastPlayedSongID"
        static let songListTitle = "Songs".localizedCapitalized
        static let loading = "Loading...".localizedCapitalized
        static let retry = "Retry".localizedCapitalized
        static let playerTitle = "Now Playing".localizedCapitalized
        static let play = "Play".localizedCapitalized
        static let pause = "Pause".localizedCapitalized
        static let forward = "Forward".localizedCapitalized
        static let backward = "Backward".localizedCapitalized
        static let download = "Download".localizedCapitalized
        static let downloading = "Downloading...".localizedCapitalized
        static let downloaded = "Downloaded".localizedCapitalized
        static let deleted = "Deleted".localizedCapitalized
        static let nowPlaying = "Now Playing".localizedCapitalized
        static let currentPosition = "Current Position".localizedCapitalized
        static let alreadyPlaying = "Player is already playing.".localizedCapitalized
        static let downloadError = "Download failed:".localizedCapitalized
        static let durationError = "Failed to load duration:".localizedCapitalized
        static let deletionError = "Failed to delete song:".localizedCapitalized
        static let ok = "OK".localizedCapitalized
    }
    
    struct Images {
        static let musicNote = "music.note.house.fill"
        static let pause = "pause.circle.fill"
        static let play = "play.circle.fill"
        static let restart = "arrow.clockwise.circle.fill"
        static let download = "arrow.down.circle.fill"
        static let deleteDownload = "xmark.circle.fill"
    }
}
