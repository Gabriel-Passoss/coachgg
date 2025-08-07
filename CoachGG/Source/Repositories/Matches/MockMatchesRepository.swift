//
//  MockMatchesRepository.swift
//  CoachGG
//
//  Created by Gabriel on 01/08/25.
//

import Foundation

class MockMatchesRepository: MatchesRepository {
    var delay: Int = 0
    
    init(delay: Int = 0) {
        self.delay = delay
    }
    
    func getRecentMatches(puuid: String) async throws -> [Match] {
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        guard let url = Bundle.main.url(forResource: "RecentMatchesMock", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load RecentMatchesMock.json file")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let matches = try decoder.decode([Match].self, from: data)
            return matches
        } catch {
            print("Failed to decode RecentMatchesMock: \(error)")
            return []
        }
    }
}
