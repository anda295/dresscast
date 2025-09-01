import SwiftUI

struct ShareableOutfitStory: View {
    var temperature: Int
    var icon: String
    var weatherMessage: String
    var outfitIcon: String
    var outfitTitle: String
    var outfitImage: String
    var tips: [String]
    var locationName: String
var theme: WeatherTheme
    var body: some View {
        ZStack {
            // Gradient background (full story)
            LinearGradient(
                colors: [Color(red: 0.35, green: 0.75, blue: 0.95),  // top
                         Color(red: 0.15, green: 0.45, blue: 0.85)], // bottom
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 20) {
                Spacer(minLength: 80)

                // White card with outfit info
                ShareableOutfitCard(
                    temperature: temperature,
                    icon: icon,
                    weatherMessage: weatherMessage,
                    outfitIcon: outfitIcon,
                    outfitTitle: outfitTitle,
                    outfitImage: outfitImage,
                    tips: tips,
                    locationName: locationName ?? "",
                    theme: theme
                )
                .padding(.horizontal, 48)
                .shadow(radius: 12, y: 6)

                Spacer()

                // Small brand footer
                Text("DressCast")
                    .font(.headline)
                    .opacity(0.85)
                    .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
        .frame(width: 1080, height: 1920) // story aspect
    }
}

/// Maps WMO/Open‑Meteo weather codes + temperature to a brand `WeatherTheme`.
/// - Parameters:
///   - code: WMO weather code (e.g. 0, 1, 61, 80, 95…)
///   - temperatureC: Current temperature in °C (used to detect `.hot`)
/// - Returns: A `WeatherTheme` used by the share card gradient.
func theme(for code: Int, temperatureC: Int) -> WeatherTheme {
    // Optional "hot" override: sunny/warm conditions + high temp
    if temperatureC >= 30 {
        switch code {
        case 0, 1, 2, 3, 45, 48: // clear/partly/overcast/fog but very hot
            return .hot
        default: break
        }
    }

    switch code {
    case 0:
        return .clear                    // clear sky
    case 1, 2:
        return .partlyCloudy             // mainly clear / partly cloudy
    case 3, 45, 48:                      // overcast + fog
        return .cloudy
    case 51, 53, 55, 56, 57,             // drizzle + freezing drizzle
         61, 63, 65, 66, 67,             // rain + freezing rain
         80, 81, 82,                     // rain showers
         95, 96, 99:                     // thunderstorms (treat as rainy theme)
        return .rain
    case 71, 73, 75, 77,                 // snow + snow grains
         85, 86:                         // snow showers
        return .snow
    default:
        return .partlyCloudy
    }
}

