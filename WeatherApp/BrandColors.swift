import SwiftUI

// MARK: - HEX convenience
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0; Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:(a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - DressCast brand
enum Brand {
    // Primary sky gradient
    static let skyStart = Color(hex: "#3AA6FF")
    static let skyEnd   = Color(hex: "#0076FF")

    // Accent (sunny orange)
    static let accent   = Color(hex: "#FFB84C")

    // Supporting accents (optional use)
    static let sun      = Color(hex: "#FFD93D")
    static let rain     = Color(hex: "#4DB6FF")
    static let cloud    = Color(hex: "#C6C6C6")

    // Neutrals
    static let cardLight = Color.white
    static let cardDark  = Color(hex: "#1E1E1E")
    static let textPrimaryLight   = Color(hex: "#1A1A1A")
    static let textSecondaryLight = Color(hex: "#555555")
}

enum WeatherTheme {
    case clear, partlyCloudy, cloudy, rain, snow, hot

    var gradient: LinearGradient {
        switch self {
        case .clear, .partlyCloudy:
            return LinearGradient(colors: [Brand.skyStart, Brand.skyEnd],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .cloudy:
            return LinearGradient(colors: [Color(hex:"#8EA3B8"), Color(hex:"#5D7089")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .rain:
            return LinearGradient(colors: [Color(hex:"#5FA8FF"), Color(hex:"#2F5DB3")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .snow:
            return LinearGradient(colors: [Color(hex:"#B7E4FF"), Color(hex:"#6FB3E8")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .hot:
            return LinearGradient(colors: [Color(hex:"#FF8F4C"), Color(hex:"#FF5A3A")],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
