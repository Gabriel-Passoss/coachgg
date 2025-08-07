//
//  SummonerViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var player: Player
    @Published var recentMatches: [Match] = []
    
    @Published var error: Error?
    @Published var showError: Bool = false
    
    @Published var isPlayerLoading: Bool = false
    
    @Published var isRecentMatchesLoading: Bool = false
    
    private let summonersRepository: SummonersRepository
    private let matchesRepository: MatchesRepository
    
    init(
        summonersRepository: SummonersRepository,
        matchesRepository: MatchesRepository,
        player: Player
    ) {
        self.summonersRepository = summonersRepository
        self.matchesRepository = matchesRepository
        self.player = player
    }
    
    func loadPlayer() {
        isPlayerLoading = true
        
        Task(priority: .medium) {
            do {
                let fetchedSummoner = try await summonersRepository.getSummoner(name: player.summoner.summonerName, tag: player.summoner.summonerTag)
                await MainActor.run {
                    self.player.summoner = fetchedSummoner.summoner
                    self.player.riotAccount = fetchedSummoner.account
                    self.isPlayerLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    isPlayerLoading = false
                }
            }
        }
    }
    
    func getRecentMatches() {
        isRecentMatchesLoading = true
        
        Task {
            do {
                let fetchedRecentMatches = try await matchesRepository.getRecentMatches(puuid: player.riotAccount.puuid)
                await MainActor.run {
                    self.recentMatches = fetchedRecentMatches
                    self.isRecentMatchesLoading = false
                }
            } catch {
                await MainActor.run {
                    
                }
            }
        }
    }
}
