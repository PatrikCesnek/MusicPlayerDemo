//
//  FileDownloadManager.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 14/04/2025.
//

import Foundation

final class FileDownloadManager {
    static let shared = FileDownloadManager()
    private init() {}

    func downloadFile(from url: URL, fileName: String) async throws -> URL {
        let (data, _) = try await URLSession.shared.data(from: url)

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(fileName)

        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }

    func fileExists(named fileName: String) -> Bool {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }

    func localFileURL(named fileName: String) -> URL? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(fileName)
        return fileExists(named: fileName) ? fileURL : nil
    }
    
    func deleteFile(named fileName: String) throws {
        let fileURL = localFileURL(named: fileName)
        if let fileURL = fileURL, FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}
