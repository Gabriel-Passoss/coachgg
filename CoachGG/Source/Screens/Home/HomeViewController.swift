//
//  SummonerViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import Foundation

class HomeViewController: ObservableObject {
    @Published var summoner: Summoner?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = SummonerRepository()
    
    func getSummoner(name: String, tag: String) {
        isLoading = true
        
        Task {
            do {
                let fetchedSummoner = try await repository.getSummoner(name: name, tag: tag)
                await MainActor.run {
                    self.summoner = fetchedSummoner.summoner
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
