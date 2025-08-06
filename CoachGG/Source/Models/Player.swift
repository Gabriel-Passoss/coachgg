//
//  Player.swift
//  CoachGG
//
//  Created by Gabriel on 06/08/25.
//

import Foundation
import SwiftData

@Model
class Player {
    var summoner: Summoner
    var riotAccount: RiotAccount
    var region: Region
        
    init(summoner: Summoner, riotAccount: RiotAccount, region: Region) {
        self.summoner = summoner
        self.riotAccount = riotAccount
        self.region = region
    }
}
