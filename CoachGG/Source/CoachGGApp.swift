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
            ZStack {
                switch router.currentRoute {
                case .splash:
                    SplashView()
                        .transition(.opacity)
                        
                case .login:
                    SummonerFormView(
                        summonersRepository: DIContainer.shared.resolve(SummonersRepository.self)
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    
                case .home(let player):
                    HomeView(
                        summonersRepository: DIContainer.shared.resolve(SummonersRepository.self),
                        matchesRepository: DIContainer.shared.resolve(MatchesRepository.self),
                        reportsRepository: DIContainer.shared.resolve(ReportsRepository.self),
                        player: player
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .preferredColorScheme(.dark)
            .animation(.easeInOut(duration: 0.5), value: router.currentRoute)
        }
        .environmentObject(router)
        .modelContainer(for: EndedMatchReport.self)
    }
    
    private func setupDependencies() {
        DIContainer.shared.register(SummonersRepository.self, service: APISummonersRepository())
        DIContainer.shared.register(MatchesRepository.self, service: MockMatchesRepository())
        DIContainer.shared.register(ReportsRepository.self, service: APIReportsRepository())
    }
}
