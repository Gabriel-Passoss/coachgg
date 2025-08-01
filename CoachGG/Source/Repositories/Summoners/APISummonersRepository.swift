//
//  SummonerRepository.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

enum APISummonerError: Error, LocalizedError {
    case invalidUrl
    case invalidResponse
    case summonerNotFound
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL, please try again later."
        case .invalidResponse:
            return "Invalid response, please try again later."
        case .summonerNotFound:
            return "Summoner not found."
        case .invalidData:
            return "Invalid data, please try again later."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}


class APISummonersRepository: SummonersRepository {
    let baseUrl = "http://localhost:3000"
    
    func getSummoner(name: String, tag: String) async throws -> GetSummonerResponse {
        guard let url = URL(string: "\(baseUrl)/BR1/summoners/\(name)/\(tag)") else { throw APISummonerError.invalidUrl}
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw APISummonerError.invalidResponse
        }
        
        if response.statusCode == 404 {
            throw APISummonerError.summonerNotFound
        }
        
        guard let summoner = try? JSONDecoder().decode(GetSummonerResponse.self, from: data) else {
            throw APISummonerError.invalidData
        }
        
        return summoner
    }
}
