//
//  ContentView.swift
//  CoachGG
//
//  Created by Gabriel on 26/06/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var showAlert = false
    @Environment(\.modelContext) var context
    
    init(
        summonersRepository: SummonersRepository,
        matchesRepository: MatchesRepository,
        reportsRepository: ReportsRepository,
        player: Player,
    ) {
        self._viewModel = StateObject(wrappedValue: HomeViewModel(
            summonersRepository: summonersRepository,
            matchesRepository: matchesRepository,
            reportsRepository: reportsRepository,
            player: player,
        ))
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
            viewModel.context = context
            viewModel.loadPlayer()
            viewModel.getRecentMatches()
        }
        .onReceive(viewModel.$error) { error in
            if error != nil {
                showAlert = true
            }
        }
        .refreshable {
            viewModel.loadPlayer()
            viewModel.getRecentMatches()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "An error occurred"))
        }
    }
    
    @ViewBuilder
    private var summonerInfo: some View {
        HStack {
            if (viewModel.isPlayerLoading) {
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
            } else {
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        AsyncImage(url: URL(string: viewModel.player.summoner.icon)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 52, height: 52)
                        } placeholder: {
                            Group {
                                LoadingView()
                                .frame(width: 16, height: 16)
                            }
                            .frame(width: 52, height: 52)
                            .background(ColorTheme.slate800)
                            .clipShape(Circle())
                        }
                        
                        
                        Text(viewModel.player.summoner.name)
                            .foregroundStyle(ColorTheme.gray200)
                            .fontWeight(.medium)
                            .font(.subheadline)
                    }
                    
                    Text("\(viewModel.player.summoner.level)")
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
        LazyVStack(spacing: 28) {
            if viewModel.recentMatches.count > 0 {
                ForEach(viewModel.recentMatches, id: \.metadata.matchId) { item in
                    matchCardView(for: item)
                        .cornerRadius(8)
                }
                .onAppear {
                    viewModel.fetchReportsFromStorage(matchIds: viewModel.recentMatches.compactMap { $0.metadata.matchId })
                }
            } else {
                ForEach(1...20, id: \.self) { index in
                    Skeleton(shape: Rectangle())
                        .frame(maxWidth: .infinity)
                        .frame(height: 170)
                        .cornerRadius(8)
                    
                }
            }
        }
        .background(ColorTheme.slate900)
    }
    
    @ViewBuilder
    private func matchCardView(for item: Match) -> some View {
        MatchCardView(
            match: item,
            currentPlayer: viewModel.player,
            report: viewModel.endedMatchReports.first(where: { $0.matchId == item.metadata.matchId}),
            isGeneratingReport: Binding(
                get: { viewModel.isGeneratingReport[item.metadata.matchId] ?? false },
                set: { viewModel.isGeneratingReport[item.metadata.matchId] = $0 }
            ),
            generateReport: viewModel.generateReport
        )
    }
}

#Preview {
    // HomeView(summonersRepository: MockSummonersRepository(), matchesRepository: MockMatchesRepository())
}
