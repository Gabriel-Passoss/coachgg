//
//  Rank.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

struct Rank: Codable {
    let queueType: String
    let tier: String
    let rank: String
    let leaguePoints: Int
    let wins: Int
    let losses: Int
}
