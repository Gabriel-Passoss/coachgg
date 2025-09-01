//
//  CurrentMatch.swift
//  CoachGG
//
//  Created by Gabriel on 15/08/25.
//

import Foundation

struct CurrentMatchParticipant: Codable {
    let championId: Int
    let championName: String
    let championIcon: String
    let profileIcon: String
    let teamId: Int
    let puuid: String
    let spell1Icon: String
    let spell2Icon: String
}

struct CurrentMatch: Codable {
    let gameId: Int
    let gameStartTime: Int
    let participants: [CurrentMatchParticipant]
}
