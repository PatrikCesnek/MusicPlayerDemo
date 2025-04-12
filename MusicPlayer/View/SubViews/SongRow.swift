//
//  SongRow.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import SwiftUI

struct SongRow: View {
    let song: Song
    
    var body: some View {
        HStack {
            if let artworkURL = song.artworkURL {
                AsyncImage(url: artworkURL) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: Constants.Images.musicNote)
                        .resizable()
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
                Image(systemName: Constants.Images.musicNote)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SongRow(song: Mock.song)
}
