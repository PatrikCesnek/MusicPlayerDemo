//
//  APIService.swift
//  MusicPlayer
//
//  Created by Patrik Cesnek on 12/04/2025.
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    func fetchSongs(completion: @escaping (Result<[Song], Error>) -> Void) {
        guard let url = URL(string: Constants.Strings.songListURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            do {
                let songs = try JSONDecoder().decode([Song].self, from: data)
                completion(.success(songs))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    enum APIError: Error {
        case invalidURL
        case noData
    }
}

