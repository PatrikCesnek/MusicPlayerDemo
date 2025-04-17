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
    var audioManager = AudioManager.shared
    var isDownloaded: Bool = false
    var isLoading: Bool = false
    var error: String?
    
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    init(song: Song) {
        self.song = song
        checkIfDownloaded()
        setupAudio()
        configureRemoteCommands()
    }
    
    private func checkIfDownloaded() {
        isDownloaded = FileDownloadManager.shared.fileExists(named: song.fileName)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    @MainActor
    func startPlaying() async {
        isLoading = true
        
        if audioManager.currentFileName != song.fileName {
            do {
                let forceStream = !isDownloaded
                try await audioManager.loadAndPlay(
                    url: song.audioURL,
                    fileName: song.fileName,
                    song: song,
                    forceStream: forceStream
                )
                audioManager.setupNowPlaying(song: song)
            } catch {
                self.error = error.localizedDescription
                showAlert(title: Constants.Strings.playbackError, message: error.localizedDescription)
            }
        }
        
        isLoading = false
    }

    func retry() {
        Task {
            await startPlaying()
        }
    }

    func togglePlayPause() {
        if audioManager.currentFileName != song.fileName {
            Task {
                await startPlaying()
                audioManager.togglePlayPause()
            }
        } else {
            audioManager.togglePlayPause()
        }
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
    
    private func setupAudio() {
        let localFileURL = FileDownloadManager.shared.localFileURL(named: song.fileName)
        Task {
            do {
                try await audioManager.loadAndPlay(url: localFileURL ?? song.audioURL, fileName: song.fileName, song: song)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    private func configureRemoteCommands() {
        audioManager.configureRemoteCommands(togglePlayPause: togglePlayPause)
    }
}
