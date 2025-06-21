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
    @Published var showAlert: Bool = false
    
    private var forecastManager = ForecastManager()
    private var cancellables: Set<AnyCancellable> = []
    
    private let path = FileManager.cacheDirectory.appending(path: "previousForecast")
    
    init() {
        checkPermission()
        currentLocationForecast = try? LocalFileManager.retrieveFromFileManager(path: path, type: Forecast.self)
        getForecast()
        getCityForecastSubscriber()
    }
    
    private func checkPermission() {
        forecastManager.$showAlert
            .sink { [weak self] newValue in
                if let newValue = newValue {
                    self?.showAlert = newValue
                } else {
                    self?.showAlert = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func getForecast() {
        forecastManager.$currentForecast
            .sink(receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                
                if let forecast = forecast {
                    self.currentLocationForecast = forecast
                    LocalFileManager.saveToFileManager(data: forecast, path: self.path)
                }
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
