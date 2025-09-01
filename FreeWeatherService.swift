//
//  FreeWeatherService.swift
//  WeatherApp
//
//  Created by Alin Postolache on 04.08.2025.
//

import Foundation
struct UVIndexResponse: Codable {
    let daily: DailyUV
}

struct DailyUV: Codable {
    let uvIndexMax: [Double]

    enum CodingKeys: String, CodingKey {
        case uvIndexMax = "uv_index_max"
    }
}
struct FreeOpenMeteoResponse: Codable {
    let current: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case current = "current"
    }
}

struct CurrentWeather: Codable {
    let temperature: Double
    let windSpeed: Double
    let precipitation: Double
    let isDay: Int
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case windSpeed = "wind_speed_10m"
        case precipitation = "precipitation"
        case isDay = "is_day"
        case weatherCode = "weather_code"
    }
}
struct UVIndexCache {
    private static let key = "cachedUVIndex"
    private static let dateKey = "cachedUVIndexDate"

    static func save(_ uvIndex: Int) {
        UserDefaults.standard.set(uvIndex, forKey: key)
        UserDefaults.standard.set(Date(), forKey: dateKey)
    }

    static func load() -> Int? {
        guard let cachedDate = UserDefaults.standard.object(forKey: dateKey) as? Date else {
            return nil
        }

        // Invalidate after 1 day
        if Calendar.current.isDateInToday(cachedDate) {
            return UserDefaults.standard.integer(forKey: key)
        } else {
            return nil
        }
    }
}
func fetchDetailedWeather(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> Void) {
    let baseURL = "https://api.open-meteo.com/v1/forecast"
       let currentURL = "\(baseURL)?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,wind_speed_10m,precipitation,weather_code,is_day&timezone=auto"
       let uvURL = "\(baseURL)?latitude=\(lat)&longitude=\(lon)&daily=uv_index_max&timezone=auto"

       guard let url1 = URL(string: currentURL) else {
           completion(nil)
           return
       }

       let group = DispatchGroup()

       var currentWeather: CurrentWeather?
       var uvIndex: Int = UVIndexCache.load() ?? 5 // fallback to cache or 5

       group.enter()
       URLSession.shared.dataTask(with: url1) { data, _, _ in
           if let data = data,
              let decoded = try? JSONDecoder().decode(FreeOpenMeteoResponse.self, from: data) {
               currentWeather = decoded.current
           }
           group.leave()
       }.resume()

       // Only fetch UV if not cached
       if UVIndexCache.load() == nil,
          let url2 = URL(string: uvURL) {
           group.enter()
           URLSession.shared.dataTask(with: url2) { data, _, _ in
               if let data = data,
                  let decoded = try? JSONDecoder().decode(UVIndexResponse.self, from: data),
                  let todayUV = decoded.daily.uvIndexMax.first {
                   uvIndex = Int(todayUV.rounded())
                   UVIndexCache.save(uvIndex)
               }
               group.leave()
           }.resume()
       }

       group.notify(queue: .main) {
           guard let current = currentWeather else {
               completion(nil)
               return
           }

           let weather = WeatherData(
               temperature: current.temperature,
               precipitation: current.precipitation,
               windSpeed: current.windSpeed,
               uvIndex: uvIndex,
               isSnowing: current.weatherCode >= 71 && current.weatherCode <= 77,
               weatherCode: current.weatherCode
           )

           completion(weather)
       
    }
}
//func fetchDetailedWeather(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> Void) {
//    let urlStr = """
//    https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,wind_speed_10m,precipitation,weather_code,is_day&timezone=auto
//    """
//
//    guard let url = URL(string: urlStr) else {
//        completion(nil)
//        return
//    }
//
//    let task = URLSession.shared.dataTask(with: url) { data, _, error in
//        guard let data = data, error == nil else {
//            print("Request error: \(error?.localizedDescription ?? "Unknown error")")
//            completion(nil)
//            return
//        }
//
//        do {
//            let decoded = try JSONDecoder().decode(FreeOpenMeteoResponse.self, from: data)
//            let current = decoded.current
//
//            let weather = WeatherData(
//                temperature: current.temperature,
//                precipitation: current.precipitation,
//                windSpeed: current.windSpeed,
//                uvIndex: 5, // placeholder
//                isSnowing: current.weatherCode >= 71 && current.weatherCode <= 77
//            )
//
//            completion(weather)
//        } catch {
//            print("Decoding error: \(error)")
//            completion(nil)
//        }
//    }
//
//    task.resume()
//}
