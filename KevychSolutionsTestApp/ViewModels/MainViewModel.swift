//
//  MainViewModel.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var currentLocationForecast: Forecast? = nil
    @Published var cityForecast: Forecast? = nil
    
    @Published var searchText: String = ""
    //@Published var showScreen: Bool = false
    
    private var forecastManager = ForecastManager()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        getForecast()
        getCityForecastSubscriber()
    }
    
    func reloadData() {
        forecastManager.getForecast()
    }
    
    private func getForecast() {
        forecastManager.$currentForecast
            .sink(receiveValue: { [weak self] forecast in
                self?.currentLocationForecast = forecast
//                if forecast?.city.name != "Globe" {
//                    self?.showScreen = true
//                }
            })
            .store(in: &cancellables)
    }
    
    func getCityForecast(with text: String) {
        forecastManager.getForecastForCity(cityName: text)
    }
    
    func handleSearch(segue: () -> ()) {
        cityForecast = nil
        guard !searchText.isEmpty else { return }
        
        let text = searchText.replacingOccurrences(of: " ", with: "")
        getCityForecast(with: text)
        segue()
    }
    
    private func getCityForecastSubscriber() {
        cityForecast = nil
        forecastManager.$cityForecast
            .sink { [weak self] forecast in
                self?.cityForecast = forecast
            }
            .store(in: &cancellables)
    }
    
}
