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
    var isDownloaded: Bool = false
    var error: String?
    var isLoading: Bool = false
    
    init(song: Song) {
        self.song = song
        load()
    }
    
    private func load() {
        isLoading = true
        let localFileURL = FileDownloadManager.shared.localFileURL(named: song.fileName)
        audioManager.load(url: localFileURL ?? song.audioURL, fileName: song.fileName)
        isLoading = false
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

    func downloadSong() {
        Task {
            do {
                self.error = nil
                let fileURL = try await FileDownloadManager.shared.downloadFile(from: song.audioURL, fileName: song.fileName)
                print("Downloaded to \(fileURL)")
                isDownloaded = true
            } catch {
                isDownloaded = false
                self.error = Constants.Strings.downloadError + " \(error.localizedDescription)"
            }
        }
    }
    
    func deleteDownload() {
        do {
            try FileDownloadManager.shared.deleteFile(named: song.fileName)
            isDownloaded = false
            print("Deleted: \(song.fileName)")
        } catch {
            self.error = Constants.Strings.deletionError + " \(error.localizedDescription)"
        }
    }
}
