//
//  Helpers.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 13/04/2025.
//

import Foundation

struct Helpers {
    static func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
