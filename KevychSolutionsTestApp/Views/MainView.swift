//
//  ContentView.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text(vm.currentLocationForecast?.city.name ?? "No Data")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(vm.currentLocationForecast?.city.country ?? "No Data")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                if let forecast = vm.currentLocationForecast {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(forecast.list, id: \.self) { item in
                                VStack {
                                    Image(systemName: item.weather.first?.main.imageName(isDay: item.isDay) ?? "xmark")
                                        .symbolRenderingMode(.multicolor)
                                    
                                    Text(item.temp.max.description)
                                    
                                    Text(Date(timeIntervalSince1970: TimeInterval(item.dt)).description)
                                }
                                .font(.headline)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                
                Button("Click") {
                    vm.getCityForecast(for: "paris")
                }
                
                Text(vm.cityForecast?.city.name ?? "No Data")
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    MainView()
}
