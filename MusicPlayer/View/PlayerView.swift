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
                    .frame(width: 100, height: 100)
            } else {
                VStack(spacing: 20) {
                    if let artworkURL = viewModel.song.artworkURL {
                        AsyncImage(url: artworkURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                        } placeholder: {
                            EmptySongImage()
                        }
                        .frame(height: 250)
                        .padding(24)
                    }

                    Text(viewModel.song.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(viewModel.song.artist)
                        .font(.title2)
                        .foregroundColor(.secondary)

                    Spacer()

                    if viewModel.audioManager.duration > 0 && viewModel.audioManager.duration.isFinite {
                        Slider(value: $viewModel.audioManager.currentTime, in: 0...viewModel.audioManager.duration, step: 1) {
                            Text(Constants.Strings.currentPosition)
                        } minimumValueLabel: {
                            Text(Helpers.formatTime(viewModel.audioManager.currentTime))
                        } maximumValueLabel: {
                            Text(Helpers.formatTime(viewModel.audioManager.duration))
                        } onEditingChanged: { editing in
                            if !editing {
                                viewModel.seek(to: viewModel.audioManager.currentTime)
                            }
                        }
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
        .navigationTitle(Constants.Strings.nowPlaying)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PlayerView(song: Mock.song)
}
