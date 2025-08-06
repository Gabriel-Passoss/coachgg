//
//  CoachGGApp.swift
//  CoachGG
//
//  Created by Gabriel on 26/06/25.
//

import SwiftUI
import SwiftData

@main
struct CoachGGApp: App {
    var body: some Scene {
        WindowGroup {
            //HomeView(summonersRepository: APISummonersRepository(), matchesRepository: APIMatchesRepository())
            SummonerFormView()
        }
        .modelContainer(for: [Player.self])
    }
}
