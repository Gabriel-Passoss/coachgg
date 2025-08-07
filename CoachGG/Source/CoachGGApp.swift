//
//  CoachGGApp.swift
//  CoachGG
//
//  Created by Gabriel on 26/06/25.
//

import SwiftUI

@main
struct CoachGGApp: App {
    @StateObject private var router = AppRouter()
    
    init() {
        setupDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            switch router.currentRoute {
            case .login:
                SummonerFormView(
                    summonersRepository: DIContainer.shared.resolve(SummonersRepository.self)
                )
            case .home(let player):
                HomeView(
                    summonersRepository: DIContainer.shared.resolve(SummonersRepository.self),
                    matchesRepository: DIContainer.shared.resolve(MatchesRepository.self),
                    player: player
                )
            }
        }
        .environmentObject(router)
    }
    
    private func setupDependencies() {
        DIContainer.shared.register(SummonersRepository.self, service: APISummonersRepository())
        DIContainer.shared.register(MatchesRepository.self, service: APIMatchesRepository())
    }
}
