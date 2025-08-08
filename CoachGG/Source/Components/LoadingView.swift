//
//  LoadingView.swift
//  CoachGG
//
//  Created by Gabriel on 08/08/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        Image("loader-circle")
            .resizable()
            .rotationEffect(.degrees(isRotating))
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    isRotating = 360.0
                }
            }
    }
}

#Preview {
    LoadingView()
}
