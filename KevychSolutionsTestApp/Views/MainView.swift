//
//  ContentView.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import SwiftUI

struct MainView: View {
    
    let currentLocationForecast: Forecast?
    var isMainView: Bool = true
    @State private var selectedDay: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                        VStack {
                            titleSection
                            
                            if let forecast = currentLocationForecast {
                                forecastScrollView(for: forecast)
                                
                                infoGrid(for: forecast)
                            }
                            
                        }
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, isMainView ? 64 : 32)
            }
        }
        .background(
            ZStack {
                if let currentListItem = currentLocationForecast?.list.first?.weather.first, let isDay = currentLocationForecast?.list.first?.isDay {
                    GeometryReader { geo in
                        Image(currentListItem.main.backgroundImageName(isDay: isDay))
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                } else {
                    GeometryReader { geo in
                        Image(.day)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
            }
        )
    }
    
    private var titleSection: some View {
        VStack {
            if let city = currentLocationForecast?.city {
                Text(city.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(city.country)
                    .font(.title)
                    .fontWeight(.semibold)
                    .opacity(currentLocationForecast?.city.country == "" ? 0 : 1)
                
                if let weather = currentLocationForecast?.list.first?.weather.first?.main.rawValue {
                    Text(weather)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.75))
                }
                
            } else {
                ContentUnavailableView("No Results", systemImage: "magnifyingglass")
            }
        }
        .padding(.bottom, 16)
    }
    
    private func forecastScrollView(for forecast: Forecast) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text("Feels like: \(Int(forecast.list[selectedDay].feelsLike.day))°C")
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.75))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    ForEach(forecast.list.indices, id: \.self) { index in
                        let item = forecast.list[index]
                        
                        VStack(spacing: 4) {
                            Text(Date(timeIntervalSince1970: TimeInterval(item.dt)).toDayMonthString())
                                .frame(maxHeight: .infinity, alignment: .top)
                            
                            Image(systemName: item.weather.first?.main.imageName(isDay: item.isDay) ?? "cloud.fill")
                                .symbolRenderingMode(.multicolor)
                            
                            Text("\(Int(item.temp.day))°C")
                        }
                        .font(.headline)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 12))
                        .background(content: {
                            if selectedDay == index {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 5)
                                    .opacity(0.6)
                            }
                        })
                        .padding(.vertical, 8)
                        .onTapGesture {
                            withAnimation {
                                selectedDay = index
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .frame(height: 100)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private func infoGrid(for forecast: Forecast) -> some View {
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            let day = forecast.list[selectedDay]
            InfoCell(label: "Max:", makeInfoIntoDegrees: true, info: Int(day.temp.max).description, systemImage: "arrow.up")
            
            InfoCell(label: "Min:", makeInfoIntoDegrees: true, info: Int(day.temp.min).description, systemImage: "arrow.down")
            
            InfoCell(label: "Sunrise:", makeInfoIntoDegrees: false, info: Date(timeIntervalSince1970: TimeInterval(forecast.list[selectedDay].sunrise)).toHourMinute(), systemImage: "sunrise.fill", isImageOnTop: true)
            
            InfoCell(label: "Sunset:", makeInfoIntoDegrees: false, info: Date(timeIntervalSince1970: TimeInterval(forecast.list[selectedDay].sunset)).toHourMinute(), systemImage: "sunset.fill", isImageOnTop: true)
            
            InfoCell(label: "\(Int(forecast.list[selectedDay].pop * 100))%", makeInfoIntoDegrees: false, info: nil, systemImage: "cloud.rain.fill", isImageOnTop: true)
            
            InfoCell(label: "\(Int(forecast.list[selectedDay].humidity))%", makeInfoIntoDegrees: false, info: nil, systemImage: "humidity.fill", isImageOnTop: true)
            
            InfoCell(label: "Pressure:", makeInfoIntoDegrees: false, info: "\(Int(forecast.list[selectedDay].pressure)) hPa", systemImage: "gauge.with.dots.needle.50percent", isImageOnTop: true)
            
            InfoCell(label: "Wind speed:", makeInfoIntoDegrees: false, info: "\(Int(forecast.list[selectedDay].speed)) m/s", systemImage: "wind", isImageOnTop: true)
        }
        .padding(.horizontal, 16)
    }
    
}

#Preview {
    RootView()
}
