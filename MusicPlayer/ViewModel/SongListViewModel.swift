//
//  SongListViewModel.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation

@Observable
class SongListViewModel {
    var songs: [Song] = []
    var isLoading = false
    var error: String? = nil
    
    var downloadedSongs: Set<Int> = []
    
    init() {
        loadSongs()
        checkDownloadedSongs()
    }
    
    func checkDownloadedSongs() {
        for song in songs {
            if FileDownloadManager.shared.fileExists(named: song.fileName) {
                downloadedSongs.insert(song.id)
            }
        }
    }
    
    func loadSongs() {
        isLoading = true
        error = nil
        
        APIService.shared.fetchSongs { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let songs):
                    self.songs = songs
                    self.checkDownloadedSongs()
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    @MainActor
    func toggleDownload(for song: Song) {
        if downloadedSongs.contains(song.id) {
            deleteDownload(for: song)
        } else {
            download(song: song)
        }
    }
    
    @MainActor
    private func download(song: Song) {
        Task {
            do {
                _ = try await FileDownloadManager.shared.downloadFile(from: song.audioURL, fileName: song.fileName)
                downloadedSongs.insert(song.id)
                
            } catch {
                self.error = Constants.Strings.downloadError + " \(error.localizedDescription)"
            }
        }
    }
    
    private func deleteDownload(for song: Song) {
        do {
            try FileDownloadManager.shared.deleteFile(named: song.fileName)
            downloadedSongs.remove(song.id)
        } catch {
            self.error = Constants.Strings.deletionError + " \(error.localizedDescription)"
        }
    }
}
