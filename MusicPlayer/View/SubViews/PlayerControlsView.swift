//
//  PlayerControlsView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 13/04/2025.
//

import SwiftUI

struct PlayerControlsView: View {
    private let restart: () -> Void
    private let togglePlayPause: () -> Void
    private let downloadSong: () -> Void
    @Binding private var isPlaying: Bool
    
    init(
        restart: @escaping () -> Void,
        togglePlayPause: @escaping () -> Void,
        downloadSong: @escaping () -> Void,
        isPlaying: Binding<Bool>
    ) {
        self.restart = restart
        self.togglePlayPause = togglePlayPause
        self.downloadSong = downloadSong
        self._isPlaying = isPlaying
    }

    var body: some View {
        HStack(spacing: 40) {
            Button(action: {
                restart()
            }) {
                Image(systemName: Constants.Images.restart)
                    .resizable()
                    .frame(width: 44, height: 44)
            }

            Button(action: {
                togglePlayPause()
            }) {
                Image(systemName: isPlaying ? Constants.Images.pause : Constants.Images.play)
                    .resizable()
                    .frame(width: 64, height: 64)
            }

            Button(action: {
                downloadSong()
            }) {
                Image(systemName: Constants.Images.download)
                    .resizable()
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    @Previewable @State var isPlaying = false
    PlayerControlsView(
        restart: {},
        togglePlayPause: {},
        downloadSong: {},
        isPlaying: $isPlaying
    )
}
