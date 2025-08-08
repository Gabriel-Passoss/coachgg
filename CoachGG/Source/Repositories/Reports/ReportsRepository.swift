//
//  ReportsProtocol.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import Foundation

struct GenerateEndedMatchReportResponse: Decodable {
    let report: EndedMatchReport
}

protocol ReportsRepository {
    func generateEndedMatchReport(matchId: String, puuid: String) async throws -> GenerateEndedMatchReportResponse?
}
