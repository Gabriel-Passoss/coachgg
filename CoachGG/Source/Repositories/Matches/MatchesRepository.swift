//
//  MatchesRepositoryProtocol.swift
//  CoachGG
//
//  Created by Gabriel on 01/08/25.
//

import Foundation

protocol MatchesRepository {
    func getRecentMatches(puuid: String) async throws -> [Match]
}
