//
//  SplashViewModel.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import Foundation

class SplashViewModel {
    func loadPlayer() -> Player? {
        if let savedPlayer = UserDefaultsManager.shared.load(Player.self, forKey: "currentPlayer") {
            return savedPlayer
        }
        return nil
    }
}
