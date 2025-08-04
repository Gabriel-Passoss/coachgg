//
//  ContentView.swift
//  CoachGG
//
//  Created by Gabriel on 26/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showAlert = false
    
    init(summonersRepository: SummonersRepository, matchesRepository: MatchesRepository) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(summonersRepository: summonersRepository, matchesRepository: matchesRepository))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 42) {
                summonerInfo
                
                Group {
                    Text("Nenhuma partida em andamento")
                        .foregroundStyle(ColorTheme.slate300)
                        .fontWeight(.medium)
                        .font(.footnote)
                }
                .frame(height: 83)
                .frame(maxWidth: .infinity)
                .background(ColorTheme.slate800)
                .cornerRadius(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ColorTheme.slate400, style: StrokeStyle(lineWidth: 2, dash: [3]))
                }
                
                Text("Histórico de partidas")
                    .foregroundStyle(ColorTheme.gray200)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                matchHistory
            }
        }
        .scrollIndicators(.hidden)
        .padding(.top, 12)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTheme.slate900)
        .onAppear {
            viewModel.getSummoner(name: "Gandalf o Branco", tag: "QWQEQ")
        }
        .onReceive(viewModel.$error) { error in
            if error != nil {
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "An error occurred"))
        }
    }
    
    @ViewBuilder
    private var summonerInfo: some View {
        HStack {
            if (viewModel.isSummonerLoading) {
                VStack(alignment: .leading) {
                    HStack(spacing: 10,) {
                        Skeleton(shape: Circle())
                        .frame(width: 52, height: 52)
                        
                        Skeleton(shape: Rectangle())
                            .frame(width: 150, height: 15)
                            .cornerRadius(4)
                    }
                    
                    Skeleton(shape: Rectangle())
                        .frame(width: 30, height: 15)
                        .padding(.leading, 10)
                }
                Spacer()
            }
            
            if let summoner = viewModel.summoner {
                VStack(alignment: .leading) {
                    HStack(spacing: 10,) {
                        AsyncImage(url: URL(string: summoner.icon)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 52, height: 52)
                        
                        Text(summoner.name)
                            .foregroundStyle(ColorTheme.gray200)
                            .fontWeight(.medium)
                            .font(.subheadline)
                    }
                    
                    Text("\(summoner.level)")
                        .foregroundStyle(ColorTheme.slate300)
                        .font(.caption)
                        .padding(.leading, 14)
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var matchHistory: some View {
        if viewModel.account != nil {
            LazyVStack(spacing: 28) {
                ForEach(viewModel.recentMatches, id: \.metadata.matchId) { item in
                    MatchCard(match: item)
                    .clipShape(UnevenRoundedRectangle(
                       topLeadingRadius: 8,
                       topTrailingRadius: 8
                    ))
                }
            }
            .onAppear {
                viewModel.getRecentMatches(puuid: viewModel.account!.puuid)
            }
            .background(ColorTheme.slate900)
        } else {
            Spacer()
        }
    }
}

#Preview {
    HomeView(summonersRepository: MockSummonersRepository(), matchesRepository: MockMatchesRepository())
}
