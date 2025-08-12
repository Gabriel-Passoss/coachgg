//
//  SummonerViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var player: Player
    @Published var recentMatches: [Match] = []
    @Published var endedMatchReports: [EndedMatchReport] = []
    
    @Published var error: Error?
    @Published var showError: Bool = false
    
    @Published var isPlayerLoading: Bool = false
    
    @Published var isRecentMatchesLoading: Bool = false
    
    @Published var isGeneratingReport: [String: Bool] = [:]
    
    private let summonersRepository: SummonersRepository
    private let matchesRepository: MatchesRepository
    private var reportsRepository: ReportsRepository
    var context: ModelContext? = nil
    
    init(
        summonersRepository: SummonersRepository,
        matchesRepository: MatchesRepository,
        reportsRepository: ReportsRepository,
        player: Player,
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
        print("bateu aqui")
        Task {
            do {
                let response = try await reportsRepository.generateEndedMatchReport(matchId: matchId, puuid: puuid)
                if let response = response {
                    let report = EndedMatchReport(
                        matchId: response.report.matchId,
                        matchResume: response.report.matchResume,
                        pros: response.report.pros,
                        cons: response.report.cons,
                        generalWarnings: response.report.generalWarnings,
                        conclusion: response.report.conclusion
                    )
                    
                    endedMatchReports.append(report)
                    context?.insert(report)
                }
                
                isGeneratingReport[matchId] = false
            } catch {
                self.error = error
                print("An error occured while generating the report: \(error)")
                isGeneratingReport[matchId] = false
            }
        }
    }
    
    func fetchReportsFromStorage(matchIds: [String]) {
        let predicate = #Predicate<EndedMatchReport> { report in
            matchIds.contains(report.matchId)
        }
        
        let fetchDescriptor = FetchDescriptor<EndedMatchReport>(predicate: predicate)
        endedMatchReports = (try? context?.fetch(fetchDescriptor)) ?? []
    }
}
