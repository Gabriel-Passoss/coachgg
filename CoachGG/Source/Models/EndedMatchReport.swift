//
//  EndedMatchReport.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import Foundation
import SwiftData

@Model
class EndedMatchReport {
    var matchId: String
    var matchResume: String
    var pros: [String]
    var cons: [String]
    var generalWarnings: String
    var conclusion: String
    
    init(matchId: String, matchResume: String, pros: [String], cons: [String], generalWarnings: String, conclusion: String) {
        self.matchId = matchId
        self.matchResume = matchResume
        self.pros = pros
        self.cons = cons
        self.generalWarnings = generalWarnings
        self.conclusion = conclusion
    }
}

struct EndedMatchReportDTO: Codable {
    let matchId: String
    let matchResume: String
    let pros: [String]
    let cons: [String]
    let generalWarnings: String
    let conclusion: String
}
