//
//  EndedMatchReport.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import Foundation

struct EndedMatchReport: Codable {
    let matchResume: String
    let pros: [String]
    let cons: [String]
    let generalWarnings: String
    let conclusion: String
}
