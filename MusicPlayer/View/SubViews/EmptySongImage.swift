//
//  EmptySongImage.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 13/04/2025.
//

import SwiftUI

struct EmptySongImage: View {
    var body: some View {
        Image(systemName: Constants.Images.musicNote)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    EmptySongImage()
}
