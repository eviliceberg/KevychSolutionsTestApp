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
    let info: String?
    let systemImage: String?
    var isImageOnTop: Bool = false
    
    var body: some View {
        HStack {
            if let name = systemImage, !isImageOnTop {
                Image(systemName: name)
            }

            VStack(spacing: 6) {
                
                if let name = systemImage, isImageOnTop {
                    Image(systemName: name)
                }
                
                VStack {
                    if let label = label {
                        Text(label)
                            .fontWeight(.bold)
                    }
                    if let info = info {
                        Text(info + (makeInfoIntoDegrees ? " °C" : ""))
                    }
                }
            }
        }
        .foregroundStyle(.white)
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
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
