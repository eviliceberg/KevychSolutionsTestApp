//
//  Weather.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import Foundation
import SwiftUI

struct Forecast: Codable, Hashable {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [DaysList]
}

// MARK: - City
struct City: Codable, Hashable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
}

// MARK: - Coord
struct Coord: Codable, Hashable {
    let lon, lat: Double
}

// MARK: - List
struct DaysList: Codable, Hashable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg: Int
    let gust: Double
    let clouds: Int
    let pop: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, weather, speed, deg, gust, clouds, pop, rain
    }
    
    var isDay: Bool {
        let currentLocalTime = Int(Date().timeIntervalSince1970)
        return currentLocalTime >= sunrise && currentLocalTime < sunset
    }
    
}

// MARK: - FeelsLike
struct FeelsLike: Codable, Hashable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable, Hashable {
    let day, min, max, night: Double
    let eve, morn: Double
}

// MARK: - Weather
struct Weather: Codable, Hashable {
    let id: Int
    let main: Main
    let description, icon: String
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    
    func imageName(isDay: Bool) -> String {
        switch self {
        case .clear:
            "sun.max.fill"
        case .clouds:
            "cloud.sun.fill"
        case .rain:
            "cloud.sun.rain.fill"
        }
    }
    
    func backgroundImageName(isDay: Bool) -> ImageResource {
        switch self {
        case .clear:
            isDay ? .day : .night
        case .clouds:
            isDay ? .sunClouds : .nightClouds
        case .rain:
            isDay ? .sunRain : .nightRain
        }
    }
    
}
