//
//  SongRow.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import SwiftUI

struct SongRow: View {
    private let song: Song
    private let isDownloaded: Bool
    private let downloadAction: () -> Void
    
    init(
        song: Song,
        isDownloaded: Bool,
        downloadAction: @escaping () -> Void
    ) {
        self.song = song
        self.isDownloaded = isDownloaded
        self.downloadAction = downloadAction
    }
    
    var body: some View {
        HStack {
            SongImage(imageURL: song.artworkURL)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(
                action: {
                    downloadAction()
                },
                label: {
                    Image(systemName: isDownloaded ? Constants.Images.deleteDownload : Constants.Images.download)
                        .foregroundColor(isDownloaded ? .red : .blue)
                        .font(.system(size: 24))
                }
            )
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    SongRow(
        song: Mock.song,
        isDownloaded: false,
        downloadAction: {}
    )
}
