//
//  ContentView.swift
//  CoachGG
//
//  Created by Gabriel on 26/06/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 42) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 10,) {
                        AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.14.1/img/profileicon/654.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 52, height: 52)
                        
                        Text("Gandalf o Branco #QWQEQ")
                            .foregroundStyle(ColorTheme.gray200)
                            .fontWeight(.medium)
                            .font(.subheadline)
                    }
                    
                    Text("598")
                        .foregroundStyle(ColorTheme.slate300)
                        .font(.caption)
                        .padding(.leading, 14)
                }
                
                Spacer()
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
    }
}

#Preview {
    HomeView()
}
