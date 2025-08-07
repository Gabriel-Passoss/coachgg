//
//  CoachGGApp.swift
//  CoachGG
//
//  Created by Gabriel on 26/06/25.
//

import SwiftUI
import SwiftData

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
        .modelContainer(for: [Player.self])
        .environmentObject(router)
    }
    
    private func setupDependencies() {
        DIContainer.shared.register(SummonersRepository.self, service: MockSummonersRepository())
        DIContainer.shared.register(MatchesRepository.self, service: MockMatchesRepository())
    }
}
