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
                ProgressView(Constants.Strings.loading)
            } else if let error = viewModel.error {
                VStack {
                    Text(error)
                        .foregroundColor(.red)
                    Button(Constants.Strings.retry) {
                        viewModel.loadSongs()
                    }
                    .padding()
                }
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
        .onAppear {
            viewModel.loadSongs()
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
