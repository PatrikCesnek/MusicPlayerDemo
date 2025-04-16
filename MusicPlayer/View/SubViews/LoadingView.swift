//
//  LoadingView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 16/04/2025.
//

import SwiftUI

struct LoadingView: View {
    private let lineWidth: CGFloat
    private let speed: Double
    private let size: Double
    @State private var isRotating = false

    init(
        lineWidth: CGFloat,
        speed: Double,
        size: Double
    ) {
        self.lineWidth = lineWidth
        self.speed = speed
        self.size = size
    }
    
    
    var body: some View {
        Circle()
            .trim(from: 0.2, to: 0.8)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [.blue, .blue.opacity(0.5)]),
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .animation(
                .linear(duration: speed)
                .repeatForever(autoreverses: false),
                value: isRotating
            )
            .frame(width: size, height: size)
            .onAppear {
                isRotating = true
            }
    }
}

#Preview {
    LoadingView(
        lineWidth: 16,
        speed: 1,
        size: 100
    )
}
