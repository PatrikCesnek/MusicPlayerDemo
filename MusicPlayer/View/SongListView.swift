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
                ProgressView()
            } else if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retry: { viewModel.loadSongs() }
                )
                .padding(16)
            } else {
                List(viewModel.songs) { song in
                    Button {
                        selectedSong = song
                    } label: {
                        SongRow(
                            song: song,
                            isDownloaded: viewModel.downloadedSongs.contains(song.id),
                            downloadAction: {
                                viewModel.toggleDownload(for: song)
                            }
                        )
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.loadSongs()
                    viewModel.checkDownloadedSongs()
                }
                .onAppear{
                    viewModel.checkDownloadedSongs()
                }
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
