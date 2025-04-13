//
//  PlayerViewModel.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation

@Observable
class PlayerViewModel {
    let song: Song
    var audioManager = AudioManager()
    
    init(song: Song) {
        self.song = song
        audioManager.play(url: song.audioURL)
    }
    
    func togglePlayPause() {
        audioManager.togglePlayPause()
    }
    
    func seek(to time: Double) {
        audioManager.seek(to: time)
    }
}
