//
//  RiotServersEnum.swift
//  CoachGG
//
//  Created by Gabriel on 06/08/25.
//

import Foundation

enum Region: String, CaseIterable, Codable {
    case BR = "BR1"
    case EUNE = "EUN1"
    case EUW = "EUW1"
    case KR = "KR"
    case LAS = "LA2"
    case NA = "NA1"
    case OCE = "OC1"
    case TR = "TR1"
    case RU = "RU"
    case JP = "JP1"
    case PH = "PH2"
    case SG = "SG2"
    case VN = "VN2"
    
    var stringValue: String {
        switch self {
        case .BR: return "Brasil"
        case .EUNE: return "Europa Nórdica e Oriental"
        case .EUW: return "Oeste da Europa"
        case .JP: return "Japão"
        case .KR: return "Coreia do Sul"
        case .LAS: return "América do Sul"
        case .NA: return "América do Norte"
        case .OCE: return "Oceânia"
        case .PH: return "Filipinas"
        case .RU: return "Rússia"
        case .SG: return "Singapura"
        case .TR: return "Turquia"
        case .VN: return "Vietnã"
        }
    }
}
