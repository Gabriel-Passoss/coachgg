//
//  SummonerRepository.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

struct SummonerResponse: Codable {
    let account: RiotAccount
    let summoner: Summoner
}

class SummonerRepository: ObservableObject {
    let baseUrl = "http://localhost:3000"
    
    func getSummoner(name: String, tag: String) async throws -> SummonerResponse {
        let url = URL(string: "\(baseUrl)/BR1/summoners/\(name)/\(tag)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw SummonerError.invalidResponse
        }
        
        if response.statusCode == 404 {
            throw SummonerError.invalidSummoner
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SummonerResponse.self, from: data)
        } catch {
            throw SummonerError.invalidData
        }
    }
}

enum SummonerError: Error {
    case invalidResponse
    case invalidSummoner
    case invalidData
}
