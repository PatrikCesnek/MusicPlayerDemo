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
                .frame(height: 300)
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
                    Text(formatTime(viewModel.audioManager.currentTime))
                } maximumValueLabel: {
                    Text(formatTime(viewModel.audioManager.duration))
                } onEditingChanged: { editing in
                    if !editing {
                        viewModel.seek(to: viewModel.audioManager.currentTime)
                    }
                }
                .padding(16)
            }
            
            Button(
                action: {
                    viewModel.togglePlayPause()
                },
                label: {
                    Image(systemName: viewModel.audioManager.isPlaying ? Constants.Images.pause : Constants.Images.play)
                        .resizable()
                        .frame(width: 64, height: 64)
                }
            )
            
            if viewModel.audioManager.isLoading {
                ProgressView(Constants.Strings.loading)
            }

            Spacer()
        }
        .navigationTitle(Constants.Strings.nowPlaying)
        .navigationBarTitleDisplayMode(.inline)
    }

    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    PlayerView(song: Mock.song)
}
