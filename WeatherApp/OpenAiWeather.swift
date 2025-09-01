//
//  OpenAiWeather.swift
//  WeatherApp
//
//  Created by Alin Postolache on 09.05.2025.
//
import CoreLocation
import Combine

import Foundation
func fetchWeather(for location: CLLocation, completion: @escaping (String) -> Void) {
    let lat = location.coordinate.latitude
    let lon = location.coordinate.longitude
    let apiKey = "cd6c37642a4b239a36b8de62c4a5603b"
    let url = URL(string:
      "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
    )!

    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data else { return }
        if let weather = try? JSONDecoder().decode(OpenWeatherResponse.self, from: data) {
            let summary = "\(weather.weather.first?.description ?? "weather"), \(Int(weather.main.temp))°C"
            print("grade")

            print(summary)
            completion(summary)
        }
    }.resume()
}

struct OpenWeatherResponse: Decodable {
    struct Weather: Decodable { let description: String }
    struct Main: Decodable { let temp: Double }
    let weather: [Weather]
    let main: Main
}
class OutfitDetails: Identifiable,ObservableObject{
    var id = UUID()
    var title: String
    var tips: [String]
    var shortWeatherInfo: String
    var fashionType: String
    var temperature: Int
    var weatherIcon: String
    var theme: WeatherTheme
    init( title: String, shortWeatherInfo: String, fashionType: String,tips:[String],temperature:Int,weatherIcon: String,theme: WeatherTheme) {
        self.title = title
        self.shortWeatherInfo = shortWeatherInfo
        self.fashionType = fashionType
        self.tips = tips
        self.weatherIcon = weatherIcon
        self.temperature = temperature
        self.theme = theme

        
    }
    private enum CodingKeys: String, CodingKey {
           case title, extraTip, secondTip, shortWeatherInfo, fashionType
       }
}

func fetchFreeOutfitSuggestion(from weatherSummary: String, completion: @escaping (OutfitDetails) -> Void){
    
}
func fetchOutfitSuggestion(from weatherSummary: String, completion: @escaping (OutfitDetails) -> Void) {
    let prompt = "Based on this weather: \(weatherSummary), what outfit would you recommend? Respond in a fun and stylish tone like 'It’s a trench and sneakers kind of day.'. give me this type of response: {\"title\": \"It’s a trench and sneakers kind of day\", \"extraTip\":\"Bring an umbrela\", \"secondTip\":\"You might want a hoodie under\",\"shortWeatherInfo\":\"Mostly cloudy, breezy\", \"fashionType\":\"trench_outfit\"}. For fashionType plese select one from this list: [trench_outfit, summer_dress, coat_outfit, hoodie_outfit,tshirt_jeans_outfit, tshirt_shorts_outfit]"

    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
   // request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "model": "gpt-4",
        "messages": [
            ["role": "system", "content": "You are a helpful fashion assistant."],
            ["role": "user", "content": prompt]
        ],
        "temperature": 0.8
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    URLSession.shared.dataTask(with: request) { data, _, _ in
        guard let data = data else { return }
     // if let decoded = try? JSONDecoder().decode(OpenAIResponse.self, from: data) {
          // let message = decoded.choices.first?.message.content ?? ""
            var txt = "OutfitDetails"
            let json =
        //message
         "{\"title\": \"It’s a trench and sneakers kind of day\", \"extraTip\":\"Bring an umbrela\", \"secondTip\":\"You might want a hoodie under\",\"shortWeatherInfo\":\"Mostly cloudy, breezy\", \"fashionType\":\"trench_outfit\"}"
            print(json)
                 let data2 = json.data(using: .utf8)
                let decoder = JSONDecoder()
                do {
                 //   var msg =  try decoder.decode(OutfitDetails.self, from: data2!)
                    print("TST")
                   // print(msg.title)
                   // completion(msg)
                } catch {
                    print("Failed to decode OutfitDetails: \(error)")
                }
          
        //  }
  
    }.resume()
}

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
