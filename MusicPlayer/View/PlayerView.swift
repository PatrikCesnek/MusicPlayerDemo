//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 13/04/2025.
//

import SwiftUI

struct PlayerView: View {
    @State private var viewModel: PlayerViewModel

    init(song: Song) {
        _viewModel = State(initialValue: PlayerViewModel(song: song))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                ErrorView(
                    errorString: error,
                    retry: {
                        viewModel.retry()
                    }
                )
                .padding(16)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        SongImage(imageURL: viewModel.song.artworkURL)
                            .frame(height: 250)
                            .padding(24)

                        Text(viewModel.song.title)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(viewModel.song.artist)
                            .font(.title2)
                            .foregroundColor(.secondary)

                        Spacer()

                        if viewModel.audioManager.duration > 0 && viewModel.audioManager.duration.isFinite {
                            
                            WavesView(isPlaying: $viewModel.audioManager.isPlaying)

                            SliderView(
                                config: .init(
                                    currentTime: $viewModel.audioManager.currentTime,
                                    duration: viewModel.audioManager.duration,
                                    seekAction: { _ in
                                        viewModel.seek(to: viewModel.audioManager.currentTime)
                                    }
                                )
                            )
                            .padding(16)
                        }
                        
                        PlayerControlsView(
                            restart: { viewModel.restart() },
                            togglePlayPause: { viewModel.togglePlayPause() },
                            downloadSong: { viewModel.downloadSong() },
                            deleteDownload: { viewModel.deleteDownload() },
                            isDownloaded: viewModel.isDownloaded,
                            isPlaying: $viewModel.audioManager.isPlaying
                        )

                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(Constants.Strings.nowPlaying)
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            viewModel.alertTitle,
            isPresented: $viewModel.showAlert) {
                Button(Constants.Strings.ok, role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
    }
}

#Preview {
    PlayerView(song: Mock.song)
}
