//
//  SummonerFormViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 06/08/25.
//

import Foundation
import SwiftData

@MainActor
class SummonerFormViewModel: ObservableObject {
    @Published var selection: String? = nil
    @Published var summonerName: String = ""
    @Published var summonerTag: String = ""
    @Published var isLoading = false
    @Published var error: Error?
    
    private let summonersRepository: SummonersRepository
    
    init(summonersRepository: SummonersRepository) {
        self.summonersRepository = summonersRepository
    }
    
    private func verifySummoner() async -> Player? {
        do {
            let response = try await summonersRepository.getSummoner(name: summonerName, tag: summonerTag)
            return Player(summoner: response.summoner, riotAccount: response.account, region: Region.BR)
        } catch {
            self.error = error
            print("Erro ao verificar invocador: \(error)")
            isLoading = false
            return nil
        }
    }
    
    func savePlayer() async -> Player? {
        isLoading = true
        
        if let summoner = await verifySummoner() {
            let player = Player(summoner: summoner.summoner, riotAccount: summoner.riotAccount, region: Region.BR)
            UserDefaultsManager.shared.save(player, forKey: "currentPlayer")
            isLoading = false
            return player
        }
        
        isLoading = false
        return nil
    }
    
    func loadPlayer() -> Player? {
        isLoading = true
        if let savedPlayer = UserDefaultsManager.shared.load(Player.self, forKey: "currentPlayer") {
            isLoading = false
            return savedPlayer
        }
        
        isLoading = false
        return nil
    }
}
