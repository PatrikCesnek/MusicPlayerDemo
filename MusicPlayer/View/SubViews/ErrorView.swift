//
//  ErrorView.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 16/04/2025.
//

import SwiftUI

struct ErrorView: View {
    private let errorString: String
    private let retry: () -> Void
    
    init(
        errorString: String,
        retry: @escaping () -> Void
    ) {
        self.errorString = errorString
        self.retry = retry
    }
    
    var body: some View {
        VStack {
            Text(errorString)
                .foregroundColor(.red)
                .font(.title)
            Button(Constants.Strings.retry) {
                retry()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ErrorView(errorString: "Some error", retry: {} )
}
