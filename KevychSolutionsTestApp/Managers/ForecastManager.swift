//
//  ForecastManager.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import Foundation
import Combine

final class ForecastManager {
    
    @Published var currentForecast: Forecast?
    @Published var cityForecast: Forecast?
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    private var locationManager = LocationManager()
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        getCoordinates()
        print("longitude: \(longitude), latitude: \(latitude)")
        getForecast()
    }
    
    func getCoordinates() {
        locationManager.$longitude
            .combineLatest(locationManager.$latitude)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] longitude, latitude in
                self?.longitude = longitude
                self?.latitude = latitude
                self?.getForecast()
            }
            .store(in: &cancellables)
    }
    
    func getForecast() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=16&units=metric&appid=") else { return }
        
        NetworkingManager.download(url: url)
            .decode(type: Forecast.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] forecast in
                self?.currentForecast = forecast
            }
            .store(in: &cancellables)
    }
    
    func getForecastForCity(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(cityName)&cnt=16&units=metric&appid=") else { return }
        
        NetworkingManager.download(url: url)
            .decode(type: Forecast.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] forecast in
                self?.cityForecast = forecast
            }
            .store(in: &cancellables)
    }
    
    
}
