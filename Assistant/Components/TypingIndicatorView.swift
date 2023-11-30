//
//  TypingIndicatorView.swift
//  Assistant
//
//  Created by Gytis Ptašinskas on 30/11/2023.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var dot1Scale: CGFloat = 0.4
    @State private var dot2Scale: CGFloat = 0.4
    @State private var dot3Scale: CGFloat = 0.4
    
    let animation: Animation = Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
    
    var body: some View {
        HStack(spacing: 3) {
            Circle()
                .frame(width: 8, height: 8)
                .scaleEffect(dot1Scale)
            Circle()
                .frame(width: 8, height: 8)
                .scaleEffect(dot2Scale)
            Circle()
                .frame(width: 8, height: 8)
                .scaleEffect(dot3Scale)
        }
        .onAppear {
            animateDots()
        }
    }
    
    private func animateDots() {
        withAnimation(animation) {
            dot1Scale = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(self.animation) {
                self.dot2Scale = 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(self.animation) {
                self.dot3Scale = 1
            }
        }
    }
}

