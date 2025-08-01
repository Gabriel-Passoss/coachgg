//
//  SummonersRepositoryProtocol.swift
//  CoachGG
//
//  Created by Gabriel on 01/08/25.
//

import Foundation

struct GetSummonerResponse: Codable {
    let account: RiotAccount
    let summoner: Summoner
}

protocol SummonersRepository {
    func getSummoner(name: String, tag: String) async throws -> GetSummonerResponse
}
