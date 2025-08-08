//
//  MockReportsRepository.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import Foundation

enum MockReportsError: Error, LocalizedError {
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


class MockReportsRepository: ReportsRepository {
    var delay: Int = 0
    
    init (delay: Int = 0) {
        self.delay = delay
    }
    
    func generateEndedMatchReport(matchId: String, puuid: String) async throws -> GenerateEndedMatchReportResponse? {
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        guard let url = Bundle.main.url(forResource: "EndedMatchReportMock", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load EndedMatchReportMock")
            throw MockReportsError.invalidJSON
        }
        
        do {
            let decoder = JSONDecoder()
            let report = try decoder.decode(GenerateEndedMatchReportResponse.self, from: data)
            return report
        } catch {
            print("Failed to decode RecentMatchesMock: \(error)")
            throw MockReportsError.invalidData
        }
    }
}
