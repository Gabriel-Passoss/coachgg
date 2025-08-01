//
//  SummonerViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var summoner: Summoner?
    @Published var account: RiotAccount?
    @Published var recentMatches: [Match] = []
    
    @Published var error: Error?
    @Published var showError: Bool = false
    
    @Published var isSummonerLoading: Bool = false
    
    @Published var isRecentMatchesLoading: Bool = false
    
    private let summonersRepository: SummonersRepository
    private let matchesRepository: MatchesRepository
    
    init(summonersRepository: SummonersRepository, matchesRepository: MatchesRepository) {
        self.summonersRepository = summonersRepository
        self.matchesRepository = matchesRepository
    }
    
    func getSummoner(name: String, tag: String) {
        isSummonerLoading = true
        
        Task(priority: .medium) {
            do {
                let fetchedSummoner = try await summonersRepository.getSummoner(name: name, tag: tag)
                await MainActor.run {
                    self.summoner = fetchedSummoner.summoner
                    self.account = fetchedSummoner.account
                    self.isSummonerLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    isSummonerLoading = false
                }
            }
        }
    }
    
    func getRecentMatches(puuid: String) {
        isRecentMatchesLoading = true
        
        Task {
            do {
                let fetchedRecentMatches = try await matchesRepository.getRecentMatches(puuid: puuid)
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
