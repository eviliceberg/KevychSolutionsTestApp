//
//  InfoCell.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 20.06.2025.
//

import SwiftUI

struct InfoCell: View {
    
    let label: String?
    var makeInfoIntoDegrees: Bool = false
    let info: String
    let systemImage: String?
    
    var body: some View {
        VStack(spacing: 12) {
            
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .symbolRenderingMode(.multicolor)
            }
            VStack {
                if let label = label {
                    Text(label)
                        .fontWeight(.bold)
                }
                
                Text(info + (makeInfoIntoDegrees ? " °C" : ""))
            }
        }
        .foregroundStyle(.white)
        .font(.headline)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    ZStack {
        Image(.day)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        
        InfoCell(label: nil, makeInfoIntoDegrees: true, info: "weather", systemImage: "cloud")
    }
}
