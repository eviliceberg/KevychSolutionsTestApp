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
    
    @Published var latitude: Double? = nil
    @Published var longitude: Double? = nil
    
    @Published var showAlert: Bool? = false
    
    private var locationManager = LocationManager()
    
    var cancellables: Set<AnyCancellable> = []
    
    var locationCancellable: AnyCancellable? = nil
    
    init() {
        permissionStatus()
        getCoordinates()
        getForecast()
    }
    
    func permissionStatus() {
        locationManager.$showAlert
            .sink { [weak self] newValue in
                self?.showAlert = newValue
                if newValue != false {
                    self?.longitude = -122.0
                    self?.latitude = 37.33
                }
            }
            .store(in: &cancellables)
    }
    
    func getCoordinates() {
        locationManager.$longitude
            .combineLatest(locationManager.$latitude)
            .filter { lon, lat in lon != 0 && lat != 0 }
            .removeDuplicates { prev, new in
                if let prevValue1 = prev.0, let prevValue2 = prev.1, let newValue1 = new.0, let newValue2 = new.1 {
                    return abs(prevValue1 - newValue1) < 0.01 && abs(prevValue2 - newValue2) < 0.01
                }
                return false
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
        guard let latitude = latitude, let longitude = longitude, let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=16&units=metric&appid=\(AppConstants.weatherAPIKey)") else { return }
        
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
