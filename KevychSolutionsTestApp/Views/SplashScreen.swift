//
//  SplashScreen.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 20.06.2025.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                
                Text("Loading...")
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ZStack {
        Image(.day)
        
        SplashScreen()
    }
}
