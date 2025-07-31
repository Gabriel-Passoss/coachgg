//
//  Skeleton.swift
//  CoachGG
//
//  Created by Gabriel on 31/07/25.
//

import SwiftUI

struct Skeleton<S: Shape>: View {
    var shape: S
    var color: Color
        
    init(shape: S, color: Color = .gray.opacity(0.3)) {
        self.shape = shape
        self.color = color
    }
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        shape
            .fill(color)
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius)
                        .rotationEffect(.init(degrees: rotation))
                        .blendMode(.softLight)
                        .offset(x: isAnimating ? maxX : minX)
                }
            }
            .clipShape(shape)
            .compositingGroup()
            .onAppear {
                guard !isAnimating else { return }
                
                withAnimation(animation) {
                    isAnimating = true
                }
            }
            .onDisappear {
                isAnimating = false
            }
    }
    
    var rotation: Double {
        return 5
    }
    
    var animation: Animation {
        .easeOut(duration: 1.5).repeatForever(autoreverses: false)
    }
}

#Preview {
    Skeleton(shape: Circle())
        .frame(width: 200, height: 200)
}
