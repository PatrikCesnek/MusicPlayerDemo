//
//  WavesView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 18/04/2025.
//

import SwiftUI

struct WavesView: View {
    @Binding private var isPlaying: Bool
    
    init(
        isPlaying: Binding<Bool>
    ) {
        self._isPlaying = isPlaying
    }
    
    var body: some View {
        HStack {
            ForEach(0..<5) { _ in
                WaveformView(isPlaying: $isPlaying)
                    .frame(width: 10, height: 30)
                    .padding(.horizontal, 8)
            }
        }
    }
}

#Preview {
    @Previewable @State var isPlaying = true
    WavesView(isPlaying: $isPlaying)
}
