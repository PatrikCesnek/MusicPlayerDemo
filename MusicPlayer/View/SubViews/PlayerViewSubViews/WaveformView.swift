//
//  WaveformView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 16/04/2025.
//

import SwiftUI

struct WaveformView: View {
    @Binding private var level: Float
    
    init(
        level: Binding<Float>
    ) {
        self._level = level
    }

    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(Color.accentColor)
                .frame(width: geometry.size.width * 0.6, height: CGFloat(max(1, CGFloat(level) * geometry.size.height)))
                .animation(.easeInOut(duration: 0.1), value: level)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    @Previewable @State var level: Float = 0.5
    WaveformView(level: $level)
}
