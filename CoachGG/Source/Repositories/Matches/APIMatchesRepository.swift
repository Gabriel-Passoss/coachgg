//
//  MatchRepository.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

class APIMatchesRepository: MatchesRepository {
    let baseUrl = "http://localhost:3000"
    
    func getRecentMatches(puuid: String) async throws -> [Match] {
        let url = URL(string: "\(baseUrl)/BR1/matches/\(puuid)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw MatchRequestError.invalidResponse
        }
        
        if response.statusCode == 404 {
            throw MatchRequestError.invalidPUUID
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Match].self, from: data)
        } catch {
            print("JSON Decoding Error: \(error)")
            // For more details about the error:
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value of type '\(type)' not found: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error: \(decodingError)")
                }
            }
            
            throw MatchRequestError.invalidData
        }
    }
}

enum MatchRequestError: Error {
    case invalidResponse
    case invalidPUUID
    case invalidData
}
