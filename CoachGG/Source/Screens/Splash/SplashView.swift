//
//  SplashView.swift
//  CoachGG
//
//  Created by Gabriel on 07/08/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var router: AppRouter
    @State private var isVisible = false
    
    private var viewModel = SplashViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Coach.GG")
                .foregroundStyle(ColorTheme.gray100)
                .font(.system(size: 34, weight: .black))
                .opacity(isVisible ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        isVisible = true
                    } completion: {
                        Task {
                            if let player = viewModel.loadPlayer() {
                                router.navigate(to: .home(player: player))
                            } else {
                                router.navigate(to: .login)
                            }
                        }
                    }
                }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTheme.slate900)
        
    }
}

#Preview {
    SplashView()
}
