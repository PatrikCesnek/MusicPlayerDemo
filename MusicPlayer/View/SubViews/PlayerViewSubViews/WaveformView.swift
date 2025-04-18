//
//  WaveformView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 16/04/2025.
//

import SwiftUI

struct WaveformView: View {
    @Binding var isPlaying: Bool
    @State private var animatedLevel: CGFloat = 0.5

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Capsule()
                    .fill(Color.accentColor)
                    .frame(
                        width: 10,
                        height: geometry.size.height * animatedLevel
                    )
                    .animation(
                        isPlaying
                        ? .easeInOut(duration: 0.4).repeatForever(autoreverses: true)
                        : .default,
                        value: animatedLevel
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .onAppear {
                handleAnimation(for: isPlaying)
            }
            .onChange(of: isPlaying, initial: false) { _, newValue in
                handleAnimation(for: newValue)
            }
        }
    }

    private func handleAnimation(for playing: Bool) {
        if playing {
            animatedLevel = CGFloat.random(in: 0.5...1.0)
        } else {
            withAnimation(.default) {
                animatedLevel = 0
            }
        }
    }
}

#Preview {
    @Previewable @State var isPlaying: Bool = true
    WaveformView(isPlaying: $isPlaying)
}
