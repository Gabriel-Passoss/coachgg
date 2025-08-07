//
//  Summoner.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

struct Summoner: Codable {
    let icon: String
    let level: Int
    let name: String
    let ranks: [Rank]
    
    var summonerName: String {
        get {
            return name.components(separatedBy: "#")[0]
        }
    }
    
    var summonerTag: String {
        get {
            return name.components(separatedBy: "#")[1]
        }
    }
}
