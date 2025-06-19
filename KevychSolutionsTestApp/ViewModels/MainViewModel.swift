//
//  MainViewModel.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    @Published var currentLocationForecast: Forecast? = nil
    @Published var cityForecast: Forecast? = nil
    
    private var forecastManager = ForecastManager()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
       getForecast()
        getCityForecast()
    }
    
    func reloadData() {
        forecastManager.getForecast()
    }
    
    private func getForecast() {
        forecastManager.$currentForecast
            .sink(receiveValue: { [weak self] forecast in
                self?.currentLocationForecast = forecast
            })
            .store(in: &cancellables)
    }
    
    func getCityForecast(for city: String) {
        forecastManager.getForecastForCity(cityName: city)
    }
    
    private func getCityForecast() {
        forecastManager.$cityForecast
            .sink { [weak self] forecast in
                self?.cityForecast = forecast
            }
            .store(in: &cancellables)
    }
    
}
