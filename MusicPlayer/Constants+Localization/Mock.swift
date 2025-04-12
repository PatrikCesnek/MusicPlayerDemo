//
//  Mock.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation

struct Mock {
    static let songs: [Song] = [
        Song(
            id: 1,
            title: "Rise and Fall",
            artist: "Mock Artist",
            audioURL: URL(string: "https://example.com/audio1.mp3")!,
            artworkURL: URL(string: "https://example.com/artwork1.jpg")
        ),
        Song(
            id: 2,
            title: "Echoes in Time",
            artist: "The Fictives",
            audioURL: URL(string: "https://example.com/audio2.mp3")!,
            artworkURL: URL(string: "https://example.com/artwork2.jpg")
        ),
        Song(
            id: 3,
            title: "Binary Dreams",
            artist: "Synth Sunset",
            audioURL: URL(string: "https://example.com/audio3.mp3")!,
            artworkURL: nil
        )
    ]
    
    static let song: Song = songs.first!
}

