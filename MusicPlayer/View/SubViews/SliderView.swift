//
//  SliderView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 16/04/2025.
//

import SwiftUI

struct SliderConfig {
    let currentTime: Binding<Double>
    let duration: Double
    let seekAction: (Double) -> Void
}

struct SliderView: View {
    let config: SliderConfig
    
    var body: some View {
        Slider(
            value: config.currentTime,
            in: 0...config.duration,
            step: 1
        ) {
            Text(Constants.Strings.currentPosition)
        } minimumValueLabel: {
            Text(Helpers.formatTime(config.currentTime.wrappedValue))
        } maximumValueLabel: {
            Text(Helpers.formatTime(config.duration))
        } onEditingChanged: { editing in
            if !editing {
                config.seekAction(config.currentTime.wrappedValue)
            }
        }
        .padding(16)
    }
}

#Preview {
    struct SliderPreviewContainer: View {
            @State private var currentTime: Double = 30.0
            let duration: Double = 180.0
            
            var body: some View {
                SliderView(
                    config: .init(
                        currentTime: $currentTime,
                        duration: duration,
                        seekAction: { _ in }
                    )
                )
            }
        }
        
        return SliderPreviewContainer()
}
