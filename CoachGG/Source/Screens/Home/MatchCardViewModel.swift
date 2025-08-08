//
//  MatchCardViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import Foundation

@MainActor
class MatchCardViewModel: ObservableObject {
    @Published var isGeneratingReport: Bool = false
    @Published var error: Error? = nil
    @Published var endedMatchReport: EndedMatchReport?
    
    private var reportsRepository: ReportsRepository
    
    init(reportsRepository: ReportsRepository) {
        self.reportsRepository = reportsRepository
    }
    
    func generateReport(matchId: String, puuid: String) {
        isGeneratingReport = true
        
        Task {
            do {
                let report = try await reportsRepository.generateEndedMatchReport(matchId: matchId, puuid: puuid)
                self.endedMatchReport = report?.report
            } catch {
                self.error = error
                print("An error occured while generating the report: \(error)")
            }
        }
    }
}
