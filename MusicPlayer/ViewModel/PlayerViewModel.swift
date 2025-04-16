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
    var isLoading: Bool = false
    
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    init(song: Song) {
        self.song = song
        checkIfDownloaded()
        load()
    }
    
    private func checkIfDownloaded() {
        isDownloaded = FileDownloadManager.shared.fileExists(named: song.fileName)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
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
                _ = try await FileDownloadManager.shared.downloadFile(from: song.audioURL, fileName: song.fileName)
                await MainActor.run {
                    isDownloaded = true
                }
                showAlert(title: Constants.Strings.downloaded, message: song.fileName)
            } catch {
                await MainActor.run {
                    isDownloaded = false
                }
                showAlert(title: Constants.Strings.downloadError, message: error.localizedDescription)
            }
        }
    }
    
    func deleteDownload() {
        do {
            try FileDownloadManager.shared.deleteFile(named: song.fileName)
            isDownloaded = false
            showAlert(title: Constants.Strings.deleted, message: song.fileName)
        } catch {
            showAlert(title: Constants.Strings.deletionError, message: error.localizedDescription)
        }
    }
}
