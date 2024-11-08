//
//  BackgroundView.swift
//  expenses-tracker
//
//  Created by Vlad on 31/10/2024.
//

import SwiftUI

struct CircleElement: View {
    var color: Color = .white
    var size: CGFloat
    var position: CGPoint
    var opacity: Double

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size)
            .position(position)
            .opacity(opacity)
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color.accentColor.opacity(0.7).ignoresSafeArea()
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                Group {
                    CircleElement(
                        size: width * 0.2,
                        position: CGPoint(x: width * 0.1, y: height * 0.2),
                        opacity: 0.3
                    )
                    
                    CircleElement(
                        size: width * 0.25,
                        position: CGPoint(x: width * 0.9, y: height * 0.05),
                        opacity: 0.4
                    )
                    
                    CircleElement(
                        size: width * 0.2,
                        position: CGPoint(x: width * 0.4, y: height * 0.5),
                        opacity: 0.1
                    )
                    
                    CircleElement(
                        size: width * 0.1,
                        position: CGPoint(x: width * 0.5, y: height * 0.3),
                        opacity: 0.1
                    )
                    
                    CircleElement(
                        size: width * 0.16,
                        position: CGPoint(x: width * 0.9, y: height * 0.8),
                        opacity: 0.3
                    )
                    
                    CircleElement(
                        size: width * 0.2,
                        position: CGPoint(x: width * 0.1, y: height * 0.95),
                        opacity: 0.4
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct BackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            BackgroundView()
            content
        }
    }
}

extension View {
    func withBackground() -> some View {
        self.modifier(BackgroundModifier())
    }
}

#Preview {
    BackgroundView()
}
