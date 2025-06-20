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
    
    var locationCancellable: AnyCancellable? = nil
    
    init() {
        getCoordinates()
        print("longitude: \(longitude), latitude: \(latitude)")
        getForecast()
    }
    
    func getCoordinates() {
        locationManager.$longitude
            .combineLatest(locationManager.$latitude)
            .filter { lon, lat in lon != 0 && lat != 0 }
            .removeDuplicates { prev, new in
                abs(prev.0 - new.0) < 0.01 && abs(prev.1 - new.1) < 0.01
            }
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] longitude, latitude in
                self?.longitude = longitude
                self?.latitude = latitude
                self?.getForecast()
            }
            .store(in: &cancellables)
    }
    
    func getForecast() {
        locationCancellable?.cancel()
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=16&units=metric&appid=\(AppConstants.weatherAPIKey)") else { return }
        
        locationCancellable = NetworkingManager.download(url: url)
            .decode(type: Forecast.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] forecast in
                self?.currentForecast = forecast
                self?.locationCancellable?.cancel()
            }
    }
    
    func getForecastForCity(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(cityName)&cnt=16&units=metric&appid=\(AppConstants.weatherAPIKey)") else { return }
        
        NetworkingManager.download(url: url)
            .decode(type: Forecast.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] forecast in
                self?.cityForecast = forecast
            }
            .store(in: &cancellables)
    }
    
    
}
