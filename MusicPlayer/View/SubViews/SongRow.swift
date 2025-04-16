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
            SongImage(imageURL: song.artworkURL)
                .frame(width: 60, height: 60)
            
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
