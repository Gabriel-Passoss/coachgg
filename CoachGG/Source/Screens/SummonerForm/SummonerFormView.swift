//
//  SummonerFormView.swift
//  CoachGG
//
//  Created by Gabriel on 04/08/25.
//

import SwiftUI

struct SummonerFormView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel: SummonerFormViewModel
    
    init(summonersRepository: SummonersRepository) {
        self._viewModel = StateObject(wrappedValue: SummonerFormViewModel(summonersRepository: summonersRepository))
    }
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            VStack(spacing: 16) {
                VStack {
                    Text("Coach.GG")
                        .foregroundStyle(ColorTheme.gray100)
                        .font(.system(size: 34, weight: .black))
                    
                    VStack {
                        Text("Seja bem vindo(a)!")
                        Text("Insira seu nome de invocador para continuar!")
                    }
                    .foregroundStyle(ColorTheme.slate300)
                    .font(.system(size: 14))
                }
                
                DropDownView(
                    hint: "Região",
                    options: Region.allCases.map { $0.stringValue },
                    anchor: .top,
                    selection: $viewModel.selection
                )
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 12) {
                    TextField("", text: $viewModel.summonerName, prompt: Text("Nome de invocador").foregroundStyle(ColorTheme.slate400))
                        .frame(maxHeight: 32)
                        .padding(.vertical, 8)
                        .padding(.leading, 14)
                        .foregroundStyle(ColorTheme.gray100)
                        .background(ColorTheme.slate800)
                        .cornerRadius(8)
                        .font(.system(size: 14, weight: .medium))
                        .focused($isTextFieldFocused)
                    
                    Text("#")
                        .foregroundStyle(ColorTheme.slate400)
                        .font(.system(size: 16, weight: .bold))
                    
                    TextField("", text: $viewModel.summonerTag, prompt: Text("Tag").foregroundStyle(ColorTheme.slate400))
                        .frame(maxWidth: 72, maxHeight: 32)
                        .padding(.vertical, 8)
                        .padding(.leading, 14)
                        .foregroundStyle(ColorTheme.gray100)
                        .background(ColorTheme.slate800)
                        .cornerRadius(8)
                        .font(.system(size: 14, weight: .medium))
                        .focused($isTextFieldFocused)
                    
                    Spacer()
                }
                
                Button(action: {
                    Task {
                        if let response = await viewModel.getSummoner() {
                            let player = Player(summoner: response.summoner, riotAccount: response.account, region: Region.BR)
                            context.insert(player)
                            
                            router.navigate(to: .home(player: player))
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        Text("Entrar")
                            .foregroundColor(.black)
                            .font(.system(size: 14, weight: .medium))
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black)
                            .font(.system(size: 12))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 36)
                .background(ColorTheme.slate300)
                .cornerRadius(8)
                
            }
            
            Spacer()
        }
        .padding(.top, 12)
        .padding(.horizontal, 25)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTheme.slate900)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
}

#Preview {
    SummonerFormView(summonersRepository: MockSummonersRepository())
}
