//
//  BottomRoundedDashedBorder.swift
//  CoachGG
//
//  Created by Gabriel on 04/08/25.
//

import Foundation
import SwiftUI

struct BottomRoundedDashedBorder: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let inset: CGFloat = 1
        let adjustedRect = rect.insetBy(dx: inset, dy: inset)
        
        let bezierPath = UIBezierPath()
        
        // Start from top-left
        bezierPath.move(to: CGPoint(x: adjustedRect.minX, y: adjustedRect.minY))
        
        // Top edge
        bezierPath.addLine(to: CGPoint(x: adjustedRect.maxX, y: adjustedRect.minY))
        
        // Right edge
        bezierPath.addLine(to: CGPoint(x: adjustedRect.maxX, y: adjustedRect.maxY - cornerRadius))
        
        // Bottom-right corner
        bezierPath.addArc(
            withCenter: CGPoint(x: adjustedRect.maxX - cornerRadius, y: adjustedRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )
        
        // Bottom edge
        bezierPath.addLine(to: CGPoint(x: adjustedRect.minX + cornerRadius, y: adjustedRect.maxY))
        
        // Bottom-left corner
        bezierPath.addArc(
            withCenter: CGPoint(x: adjustedRect.minX + cornerRadius, y: adjustedRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )
        
        // Left edge back to start
        bezierPath.addLine(to: CGPoint(x: adjustedRect.minX, y: adjustedRect.minY))
        
        return Path(bezierPath.cgPath)
    }
}

struct BottomRoundedDashedBorderModifier: ViewModifier {
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                BottomRoundedDashedBorder(cornerRadius: 8)
                        .stroke(style: StrokeStyle(
                            lineWidth: 1.5,
                            lineCap: .round,
                            dash: [2, 3]
                        ))
                .foregroundColor(ColorTheme.slate400)
            )
    }
}

extension View {
    func bottomRoundedDashedBorder(cornerRadius: CGFloat = 10) -> some View {
        self.modifier(BottomRoundedDashedBorderModifier(cornerRadius: cornerRadius))
    }
}
