//
//  Song.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation

struct Song: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let artist: String
    let audioURL: URL
    let artworkURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artist
        case audioURL = "audio_url"
        case artworkURL = "cover_url"
    }
}
