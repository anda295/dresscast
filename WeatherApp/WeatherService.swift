//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Alin Postolache on 16.05.2025.
//

import Foundation
import CoreLocation

// MARK: - API Models
struct OpenMeteoResponse: Decodable {
    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
        let weathercode: Int
    }
    let current_weather: CurrentWeather
}

// MARK: - Weather Service (Open‑Meteo)
@MainActor
final class WeatherService: ObservableObject {
    enum WeatherAPIError: Error { case badURL, badResponse }

    static let shared = WeatherService()
    private init() {}

    /// Fetches a short textual summary (description + rounded °C) for the given CLLocation.
    /// No API key required – Open‑Meteo is completely free for non‑commercial use.
    func summary(for location: CLLocation) async throws -> String {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true&timezone=auto") else {
            throw WeatherAPIError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw WeatherAPIError.badResponse }

        let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
        let cw = decoded.current_weather

        let description = Self.description(for: cw.weathercode)
        let temperature = Int(round(cw.temperature))
        return "\(description), \(temperature)°C"
    }

    // MARK: – Helpers
    private static func description(for code: Int) -> String {
        switch code {
        case 0:               return "Clear sky"
        case 1, 2, 3:         return "Partly cloudy"
        case 45, 48:          return "Fog"
        case 51, 53, 55:      return "Drizzle"
        case 56, 57:          return "Freezing drizzle"
        case 61, 63, 65:      return "Rain"
        case 66, 67:          return "Freezing rain"
        case 71, 73, 75:      return "Snow"
        case 77:              return "Snow grains"
        case 80, 81, 82:      return "Rain showers"
        case 85, 86:          return "Snow showers"
        case 95:              return "Thunderstorm"
        case 96, 99:          return "Thunderstorm w/ hail"
        default:              return "Weather"
        }
    }
}

// MARK: - Bridging helper (if you still rely on completion handlers)
/// Drop‑in replacement for your old `fetchWeather(for:completion:)`
func fetchFreeWeather(for location: CLLocation, completion: @escaping (String) -> Void) {
    Task {
        do {
            let summary = try await WeatherService.shared.summary(for: location)
            completion(summary)
        } catch {
            completion("weather unavailable")
        }
    }
}
