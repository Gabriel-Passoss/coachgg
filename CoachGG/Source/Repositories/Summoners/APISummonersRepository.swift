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
            return "URL inválida, tente novamente mais tarde."
        case .invalidResponse:
            return "Resposta inválida, tente novamente mais tarde."
        case .summonerNotFound:
            return "Invocador não encontrado."
        case .invalidData:
            return "Dados inválidos, tente novamente mais tarde."
        case .unknown(let error):
            return "Ocorreu um erro desconhecido: \(error.localizedDescription)"
        }
    }
}


class APISummonersRepository: SummonersRepository {
    let baseUrl = "http://192.168.1.11:3000"
    
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
