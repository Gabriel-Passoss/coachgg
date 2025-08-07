//
//  Match.swift
//  CoachGG
//
//  Created by Gabriel on 17/07/25.
//

import SwiftUI

struct MatchCard: View {
    let match: Match
    let currentPlayer: Player
    
    private var currentSummoner: Participant {
        let index = match.info.participants.firstIndex(where: { $0.puuid == currentPlayer.riotAccount.puuid })!
        
        return match.info.participants[index]
    }
    
    private var currentSummonerAMA: Double {
        if currentSummoner.deaths == 0 {
            return Double(currentSummoner.kills + currentSummoner.assists)
        }
        return Double(currentSummoner.kills + currentSummoner.assists) / Double(currentSummoner.deaths)
    }
    
    private var currentSummonerCSPerMinute: Double {
        return Double(currentSummoner.totalMinionsKilled) / (Double(match.info.gameDuration) / 60.0)
    }
    
    private var currentSummonerWon: Bool {
        let winningTeamIndex = match.info.teams.firstIndex(where: { $0.win == true })!
        return currentSummoner.teamId == match.info.teams[winningTeamIndex].teamId
    }
    
    private var matchResultColor: Color {
        currentSummonerWon ? ColorTheme.cyan400 : ColorTheme.red400
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    AsyncImage(url: URL(string: currentSummoner.championIcon)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 54, height: 54)
                    .padding(.trailing, 8)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        matchResume
                        
                        HStack(spacing: 20) {
                            summonerStatistics
                            
                            HStack(spacing: 8) {
                                summonerSpells
                                
                                summonerItemsGrid
                            }
                        }
                    }
                    
                    Grid(alignment: .leading, horizontalSpacing: 6, verticalSpacing: 2) {
                        getMatchup(position: Lane.top)
                        getMatchup(position: Lane.jungle)
                        getMatchup(position: Lane.middle)
                        getMatchup(position: Lane.bottom)
                        getMatchup(position: Lane.utility)
                    }
                    .padding(.leading, 14)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, maxHeight: 108)
            }
            
            HStack {
                Spacer()
                Image(systemName: "plus.circle")
                    .foregroundStyle(ColorTheme.slate300)
                
                Text("Gerar relatório de partida")
                    .font(.caption)
                    .foregroundStyle(ColorTheme.slate300)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.clear)
            .bottomRoundedDashedBorder()
        }
        .background(ColorTheme.slate800)
    }
    
    private var matchResume: some View {
        HStack {
            Text(currentSummonerWon ? "Vitória" : "Derrota")
                .foregroundStyle(matchResultColor)
                .font(.caption)
                .fontWeight(.bold)
            
           Text("•")
                .foregroundStyle(ColorTheme.gray300)
                .font(.caption)
                .fontWeight(.bold)
            
            Text("Ranqueada Flexível")
                 .foregroundStyle(ColorTheme.gray300)
                 .font(.caption)
                 .fontWeight(.bold)
            
            Text("•")
                 .foregroundStyle(ColorTheme.gray300)
                 .font(.caption)
                 .fontWeight(.bold)
            
            Text("\(convertSecondsToMinutes(match.info.gameDuration))")
                 .foregroundStyle(ColorTheme.gray300)
                 .font(.caption)
                 .fontWeight(.bold)
        }
    }
    
    private var summonerStatistics: some View {
        VStack(alignment: .leading) {
            Text("\(currentSummoner.kills)/\(currentSummoner.deaths)/\(currentSummoner.assists)")
                .foregroundStyle(ColorTheme.gray300)
                .font(.caption)
            
            Text("\(String(format: "%.1f", currentSummonerAMA)) AMA")
                .foregroundStyle(ColorTheme.gray300)
                .font(.caption)
            
            Text("CS \(currentSummoner.totalMinionsKilled) (\(String(format: "%.1f", currentSummonerCSPerMinute)))")
                .foregroundStyle(ColorTheme.gray300)
                .font(.caption)
        }
    }
    
    private var summonerSpells: some View {
        Grid(horizontalSpacing: 4) {
            GridRow {
                AsyncImage(url: URL(string: currentSummoner.summonerSpell1Icon)) { image in
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 20, height: 20)
                
                AsyncImage(url: URL(string: currentSummoner.primaryRuneIcon)) { image in
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 20, height: 20)
            }
            
            GridRow {
                AsyncImage(url: URL(string: currentSummoner.summonerSpell2Icon)) { image in
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 20, height: 20)
                
                AsyncImage(url: URL(string: currentSummoner.secondaryRuneIcon)) { image in
                    image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 20, height: 20)
            }
        }
    }
    
    private var summonerItemsGrid: some View {
        return Grid(horizontalSpacing: 4) {
            GridRow {
                summonerItem(index: 0)
                summonerItem(index: 1)
                summonerItem(index: 2)
                summonerItem(index: 6)
            }
            GridRow {
                summonerItem(index: 3)
                summonerItem(index: 4)
                summonerItem(index: 5)
            }
        }
    }
    
    @ViewBuilder
    func summonerItem(index: Int) -> some View {
        if let item = currentSummoner.getItem(at: index) {
            AsyncImage(url: URL(string: item)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 20, height: 20)
        }
    }
    
    func getMatchup(position: Lane) -> some View {
        let matchup = match.info.participants.filter { $0.lane == position }
        
        return GridRow {
            HStack {
                AsyncImage(url: URL(string: matchup[0].championIcon)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                } placeholder: {
                    ProgressView()
                }
                
                Text(matchup[0].riotIdGameName)
                    .foregroundStyle(matchup[0].puuid == currentSummoner.puuid ? .white : ColorTheme.slate300)
                    .font(.caption2)
                    .frame(width: 60, alignment: .leading)
                
                Spacer()
            }
            
            HStack {
                AsyncImage(url: URL(string: matchup[1].championIcon)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                } placeholder: {
                    ProgressView()
                }
                
                Text(matchup[1].riotIdGameName)
                    .foregroundStyle(matchup[1].puuid == currentSummoner.puuid ? .white : ColorTheme.slate300)
                    .font(.caption2)
                    .frame(width: 60, alignment: .leading)
                
                Spacer()
            }
        }
    }
}
