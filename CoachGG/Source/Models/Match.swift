//
//  Match.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

struct MetaData: Codable {
    let dataVersion: String
    let matchId: String
    let participants: [String]
}

struct Participant: Codable {
    let kills: Int
    let deaths: Int
    let assists: Int
    let totalMinionsKilled: Int
    let champLevel: Int
    let championId: Int
    let championName: String
    let championIcon: String
    let goldEarned: Int
    let lane: Lane
    let primaryRuneIcon: String
    let secondaryRuneIcon: String
    let item0: String?
    let item1: String?
    let item2: String?
    let item3: String?
    let item4: String?
    let item5: String?
    let item6: String?
    let participantId: Int
    let profileIcon: String
    let puuid: String
    let riotIdGameName: String
    let riotIdTagline: String
    let summonerSpell1Icon: String
    let summonerSpell2Icon: String
    let summonerLevel: Int
    let summonerName: String
    let teamId: Int
    let visionScore: Int
    let win: Bool
}

struct Team: Codable {
    let teamId: Int
    let win: Bool
}

struct Info: Codable {
    let gameDuration: Int
    let gameMode: String
    let participants: [Participant]
    let queueId: Int
    let teams: [Team]
}

struct Match: Codable {
    let metadata: MetaData
    let info: Info
}

enum Lane: String, Codable {
    case top = "TOP"
    case jungle = "JUNGLE"
    case middle = "MIDDLE"
    case bottom = "BOTTOM"
    case utility = "UTILITY"
}
