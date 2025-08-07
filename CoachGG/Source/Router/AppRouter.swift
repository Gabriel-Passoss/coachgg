//
//  Router.swift
//  CoachGG
//
//  Created by Gabriel on 06/08/25.
//

import SwiftUI

import Foundation

enum AppRoute {
    case login
    case home(player: Player)
}

@MainActor
class AppRouter: ObservableObject {
    @Published var currentRoute: AppRoute = .login
    
    func navigate(to route: AppRoute) {
        currentRoute = route
    }
}
