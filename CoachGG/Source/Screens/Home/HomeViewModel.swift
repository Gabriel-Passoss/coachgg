//
//  SummonerViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var player: Player
    @Published var recentMatches: [Match] = []
    @Published var endedMatchReport: [EndedMatchReport] = []
    
    @Published var error: Error?
    @Published var showError: Bool = false
    
    @Published var isPlayerLoading: Bool = false
    
    @Published var isRecentMatchesLoading: Bool = false
    
    @Published var isGeneratingReport: [String: Bool] = [:]
    
    private let summonersRepository: SummonersRepository
    private let matchesRepository: MatchesRepository
    private var reportsRepository: ReportsRepository
    
    init(
        summonersRepository: SummonersRepository,
        matchesRepository: MatchesRepository,
        reportsRepository: ReportsRepository,
        player: Player
    ) {
        self.summonersRepository = summonersRepository
        self.matchesRepository = matchesRepository
        self.reportsRepository = reportsRepository
        self.player = player
    }
    
    func loadPlayer() {
        isPlayerLoading = true
        
        Task(priority: .medium) {
            do {
                let fetchedSummoner = try await summonersRepository.getSummoner(name: player.summoner.summonerName, tag: player.summoner.summonerTag)
                self.player.summoner = fetchedSummoner.summoner
                self.player.riotAccount = fetchedSummoner.account
                self.isPlayerLoading = false
            } catch {
                self.error = error
                isPlayerLoading = false
            }
        }
    }
    
    func getRecentMatches() {
        isRecentMatchesLoading = true
        
        Task {
            do {
                let fetchedRecentMatches = try await matchesRepository.getRecentMatches(puuid: player.riotAccount.puuid)
                self.recentMatches = fetchedRecentMatches
                self.isRecentMatchesLoading = false
            } catch {
                self.error = error
                self.isRecentMatchesLoading = false
            }
        }
    }
    
    func generateReport(matchId: String, puuid: String) {
        isGeneratingReport[matchId] = true
        
        Task {
            do {
                let report = try await reportsRepository.generateEndedMatchReport(matchId: matchId, puuid: puuid)
                self.endedMatchReport.append(report!.report)
                isGeneratingReport[matchId] = false
            } catch {
                self.error = error
                print("An error occured while generating the report: \(error)")
                isGeneratingReport[matchId] = false
            }
        }
    }
}
