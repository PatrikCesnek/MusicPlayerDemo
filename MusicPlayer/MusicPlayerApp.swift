//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SongListView()
            }
        }
    }
}
