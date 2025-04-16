//
//  SongImage.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 16/04/2025.
//

import SwiftUI

struct SongImage: View {
    private let imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    var body: some View {
        if let artworkURL = imageURL {
            AsyncImage(url: artworkURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
            } placeholder: {
                EmptySongImage()
            }
            
        } else {
            EmptySongImage()
        }
    }
}

#Preview {
    SongImage(imageURL: nil)
}
