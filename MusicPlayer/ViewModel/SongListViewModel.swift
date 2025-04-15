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
    
    func loadSongs() {
        isLoading = true
        error = nil
        
        APIService.shared.fetchSongs { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let songs):
                    self.songs = songs
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
