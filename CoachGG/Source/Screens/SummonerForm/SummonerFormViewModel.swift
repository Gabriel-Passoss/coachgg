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
    
    func getSummoner() async -> GetSummonerResponse? {
        isLoading = true
        
        do {
            let response = try await summonersRepository.getSummoner(name: summonerName, tag: summonerTag)
            self.isLoading = false
            return response
        } catch {
            self.error = error
            print("Erro ao salvar o invocador: \(error)")
            isLoading = false
            return nil
        }
    }
}
