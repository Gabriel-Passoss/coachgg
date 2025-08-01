//
//  MockSummonersRepository.swift
//  CoachGG
//
//  Created by Gabriel on 01/08/25.
//

import Foundation

enum MockSummonerError: Error, LocalizedError {
    case invalidJSON
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return "Invalid json data, please try again later."
        case .invalidData:
            return "Invalid data, please try again later."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}

class MockSummonersRepository: SummonersRepository {
    func getSummoner(name: String, tag: String) async throws -> GetSummonerResponse {
        guard let url = Bundle.main.url(forResource: "GetSummonerMock", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load RecentMatchesMock.json file")
            throw MockSummonerError.invalidJSON
        }
        
        do {
            let decoder = JSONDecoder()
            let matches = try decoder.decode(GetSummonerResponse.self, from: data)
            return matches
        } catch {
            print("Failed to decode RecentMatchesMock: \(error)")
            throw MockSummonerError.invalidData
        }
    }
}
