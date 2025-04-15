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

        let localFileURL = FileDownloadManager.shared.localFileURL(named: song.fileName)
        audioManager.load(url: localFileURL ?? song.audioURL, fileName: song.fileName)
    }
    
    func togglePlayPause() {
        audioManager.togglePlayPause()
    }
    
    func seek(to time: Double) {
        audioManager.seek(to: time)
    }
    
    func restart() {
        audioManager.restart()
    }

    func downloadSong() async {
        do {
            let fileURL = try await FileDownloadManager.shared.downloadFile(from: song.audioURL, fileName: song.fileName)
            print("Downloaded to: \(fileURL.path)")
        } catch {
            print("Download failed: \(error)")
        }
    }
}
