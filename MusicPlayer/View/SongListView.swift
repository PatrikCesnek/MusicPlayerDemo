//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import SwiftUI

struct SongListView: View {
    @State private var viewModel = SongListViewModel()
    @State private var selectedSong: Song?
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(
                    lineWidth: 16,
                    speed: 1,
                    size: 100
                )
            } else if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retry: { viewModel.loadSongs() }
                )
            } else {
                List(viewModel.songs) { song in
                    Button {
                        selectedSong = song
                    } label: {
                        SongRow(song: song)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(Constants.Strings.songListTitle)
        .navigationDestination(item: $selectedSong) { song in
            PlayerView(song: song)
        }
    }
       
}

#Preview {
    SongListView()
}
