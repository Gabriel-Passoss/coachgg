//
//  SummonerFormViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 06/08/25.
//

import Foundation
import SwiftData

class SummonerFormViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    
    private let context: ModelContext
    private let summonersRepository: SummonersRepository
    
    init(context: ModelContext, summonersRepository: SummonersRepository) {
        self.context = context
        self.summonersRepository = summonersRepository
    }
    
    func savePlayer(summonerName: String, summonerTag: String, region: Region) {
        isLoading = true
        print("Bateu aqui")
        
        Task(priority: .medium) {
            do {
                let response = try await summonersRepository.getSummoner(name: summonerName, tag: summonerTag)
                await MainActor.run {
                    let player = Player(summoner: response.summoner, riotAccount: response.account, region: region)
                    context.insert(player)
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    print("Erro ao salvar o invocador: \(error)")
                    isLoading = false
                }
            }
        }
    }
}
