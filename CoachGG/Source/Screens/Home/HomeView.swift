//
//  ContentView.swift
//  CoachGG
//
//  Created by Gabriel on 26/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewController()
    
    var body: some View {
        VStack(spacing: 42) {
            HStack {
                if (viewModel.isLoading) {
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
            
            Group {
                Text("Nenhuma partida em andamento")
                    .foregroundStyle(ColorTheme.slate300)
                    .fontWeight(.medium)
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity, maxHeight: 83)
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
            
            
            
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTheme.slate900)
        .onAppear {
            viewModel.getSummoner(name: "Gandalf o Branco", tag: "QWQEQ")
        }
    }
}

#Preview {
    HomeView()
}
