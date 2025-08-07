//
//  Router.swift
//  CoachGG
//
//  Created by Gabriel on 06/08/25.
//

import SwiftUI

import Foundation

enum AppRoute: Equatable {
    case splash
    case login
    case home(player: Player)
    
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.splash, .splash):
            return true
        case (.login, .login):
            return true
        case (.home(let lhsPlayer), .home(let rhsPlayer)):
            return lhsPlayer.riotAccount.puuid == rhsPlayer.riotAccount.puuid
        default:
            return false
        }
    }
}

@MainActor
class AppRouter: ObservableObject {
    @Published var currentRoute: AppRoute = .splash
    
    func navigate(to route: AppRoute) {
        currentRoute = route
    }
}
