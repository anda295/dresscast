import Foundation
struct DailyTips {
    static let cold = [
        "🧤 Wear layers and cover your head.",
        "🧣 Don’t skip the thermal base layer.",
        "🥾 Waterproof boots and gloves highly recommended.",
        "🧥 Thick socks will save your toes.",
        "🧢 A beanie can make a huge difference."
    ]

    static let chill = [
        "🧣 Bring gloves or a scarf.",
        "🧤 A beanie wouldn’t hurt.",
        "🧥 Thermal socks recommended if you’re walking.",
        "🧥 Consider wearing a hoodie under your coat."
    ]

    static let rain = [
        "🌂 Bring an umbrella.",
        "🧥 Layer up with a waterproof shell.",
        "🧼 Waterproof shoes recommended.",
        "💦 Avoid suede or fabric sneakers today."
    ]

    static let wind = [
        "💨 Add a windbreaker.",
        "🧥 Zip your jacket — gusts are no joke.",
        "🎒 Avoid loose accessories.",
        "💨 Tie your hair up if long."
    ]

    static let uv = [
        "🕶️ Don’t forget sunscreen and sunglasses.",
        "🧢 A cap will help keep UV off your face.",
        "☀️ Stick to the shade when possible.",
        "🧴 Reapply sunscreen if you’re out all day."
    ]

    static let snow = [
        "❄️ Insulated boots and gloves advised.",
        "🧤 Snow days = glove days.",
        "🥶 Layer up under your outerwear.",
        "🧣 Cover your ears from wind chill."
    ]
}

struct WeatherData {
    let temperature: Double         // in Celsius
    let precipitation: Double       // mm
    let windSpeed: Double           // km/h
    let uvIndex: Int
    let isSnowing: Bool
    let weatherCode: Int? // 
}
struct OutfitDescription {
    let headline: String           // e.g. "It’s a trench and sneakers kind of day"
    let subheadline: String        // e.g. "Mostly cloudy, breezy"
    let tips: [String]
    let imageName: String
    let temperature:Int// e.g. ["Bring an umbrella", "You might want a hoodie under"]
    let themeForShare:WeatherTheme
}
struct OutfitRecommendation {
    let tops: [String]
    let bottoms: [String]
    let outerwear: [String]
    let footwear: [String]
    let accessories: [String]
}
private func perceivedTemp(_ actual: Double,
                               profile: ColdProfile) -> Double {
    switch profile {
    case .runCold:  return actual - 3   // feels 3 °C colder
    case .runHot:   return actual + 3   // feels 3 °C warmer
    case .neutral:  return actual
    }
}
// Unique random picker with seeded determinism
private func pickUnique(from source: [String],
                        excluding already: inout Set<String>,
                        count: Int,
                        seed: Int) -> [String] {
    var generator = SeededGenerator(seed: UInt64(seed))
    var pool = source.filter { !already.contains($0) }
    pool.shuffle(using: &generator)
    let picked = Array(pool.prefix(count))
    already.formUnion(picked)
    return picked
}



private func ensureMinimumTips(_ tips: inout [String],
                               minCount: Int,
                               weather: WeatherData,
                               feels: Double,
                               style: BroadStyle,
                               seed: Int) {
    guard tips.count < minCount else { return }
    var used = Set(tips)

    // 1) Style-specific prioritized sources
    let styled = styleSources(for: style, feels: feels, weather: weather)

    // 2) Your existing global DailyTips as secondary sources
    var global: [[String]] = []
    if weather.precipitation > 0 { global.append(DailyTips.rain) }
    if weather.isSnowing         { global.append(DailyTips.snow) }
    if weather.windSpeed > 20    { global.append(DailyTips.wind) }
    if weather.uvIndex > 6       { global.append(DailyTips.uv) }
    if feels < 0                 { global.append(DailyTips.cold) }
    else if feels < 10           { global.append(DailyTips.chill) }

    // 3) Neutral backup
    let generalFallback = [
        "👟 Comfortable shoes go a long way.",
        "🎒 Layer smart so you can adjust.",
        "💧 Stay hydrated.",
        "🧴 Keep a small sunscreen in your bag.",
        "🧢 A cap helps with wind & sun."
    ]

    var s = seed

    // Fill from style-first sources
    for src in styled where tips.count < minCount {
        let need = minCount - tips.count
        tips += pickUnique(from: src, excluding: &used, count: need, seed: s)
        s += 1
    }

    // Then from global DailyTips
    for src in global where tips.count < minCount {
        let need = minCount - tips.count
        tips += pickUnique(from: src, excluding: &used, count: need, seed: s)
        s += 1
    }

    // Finally, neutral fallback if still short
    if tips.count < minCount {
        let need = minCount - tips.count
        tips += pickUnique(from: generalFallback, excluding: &used, count: need, seed: s + 500)
    }
}


func generateOutfitText(for weather: WeatherData,coldProfile: ColdProfile = .neutral,gender: Gender = .female,style: BroadStyle = . casual) -> OutfitDescription {
    func oneOf(_ options: [String], seed: Int) -> String {
        var generator = SeededGenerator(seed: UInt64(seed))
        return options.randomElement(using: &generator) ?? options.first!
    }

    let dateSeed = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
    var headline = ""
    var subheadline = ""
    var tips = [String]()
    var imageName = "fallback"
    // 🌦️ Subheadline based on weather code
    let weatherCode = weather.weatherCode ?? 0
    switch weatherCode {
    case 80...82:
        subheadline = oneOf([
            "⛈️ Showers expected — don’t leave without a hood.",
            "🌧️ Expect bursts of rain throughout the day.",
            "⛈️ It’s one of those umbrella-or-regret days.",
            "🌧️ Might get caught in a surprise downpour!"
        ], seed: dateSeed + 1)
    case 95:
        subheadline = oneOf([
            "🌩️ Storm's coming — stay safe and stay dry.",
            "🌩️ Thunder in the forecast. Keep your gear waterproof.",
            "⚡️ Electrical storm vibes. Layer up smart.",
            "🌧️ Rain + thunder — today’s mood is dramatic."
        ], seed: dateSeed + 2)
    case 96...99:
        subheadline = oneOf([
            "🌩️ Hail and thunder. It's a day for serious outerwear.",
            "🧊 Thunderstorms with hail. Avoid soft soles.",
            "⚠️ Wild weather incoming — brace for thunder & ice.",
            "🌩️ Hailstorm energy. Hard shell jacket recommended."
        ], seed: dateSeed + 3)
    default:
        subheadline = oneOf([
            "🌤️ Mixed skies today — play it safe with layers.",
            "⛅️ It’s a little of everything out there.",
            "🌤️ A weather sampler pack: sun, clouds, maybe more.",
            "🌦️ No promises from the sky today — be ready for anything."
        ], seed: dateSeed + 4)
    }

    let feels = perceivedTemp(weather.temperature, profile: coldProfile)
    let tempBand = band(for: feels, precipitation: weather.precipitation)

    // Get a merged pool for today’s gender/style
    let pool = HeadlineLibrary.pool(for: tempBand, gender: gender, style: style)
    headline = oneOf(pool, seed: dateSeed + 500)

    // Keep your existing “add umbrella” or extra hoodie tip logic if you want:
    if tempBand == .tenTo18Rain { tips.append("🌂 Bring an umbrella.") }
    if tempBand == .tenTo18Dry  { tips.append("🧥 You might want a hoodie under.") }
    if tempBand == .over30      { tips.append("💧 Hat, water, shade — stay cool.") }

    if weather.precipitation > 2 {
            tips += manyOf(DailyTips.rain, count: 2, seed: dateSeed + 50)
        }

        if weather.isSnowing {
            tips += manyOf(DailyTips.snow, count: 2, seed: dateSeed + 60)
        }

        if weather.windSpeed > 20 {
            tips += manyOf(DailyTips.wind, count: 1, seed: dateSeed + 70)
        }

        if weather.uvIndex > 6 {
            tips += manyOf(DailyTips.uv, count: 2, seed: dateSeed + 80)
        }

        if weather.temperature < 0 {
            tips += manyOf(DailyTips.cold, count: 2, seed: dateSeed + 90)
        } else if weather.temperature < 10 {
            tips += manyOf(DailyTips.chill, count: 2, seed: dateSeed + 100)
        }
    
  
    
    switch weather.temperature {
    case ..<0:
        imageName = "winter_outfit"
    case 0..<10:
        imageName = "coat_outfit"
    case 10..<18:
        imageName = weather.precipitation > 0 ? "10_18_outfit" : "coat_outfit"
    case 18..<24:
        imageName = "18_24_outfit"
    case 24..<30:
        imageName = "24_30_outfit"
    default:
        imageName = "over_30_outfit"
    }
  imageName=gender.rawValue + "_" + style.rawValue + "_" + imageName
    print(imageName)
    let themeForShare = theme(for: weather.weatherCode ?? 0,
                              temperatureC: Int(weather.temperature))
    // Make sure we always have at least 2 tips
    ensureMinimumTips(&tips,
                      minCount: 2,
                      weather: weather,
                      feels: feels,
                      style: style,
                      seed: dateSeed + 777)
    return OutfitDescription(
        headline: headline,
        subheadline: subheadline,
        tips: tips,
        imageName: imageName,
        temperature: Int(weather.temperature),
                         themeForShare:themeForShare
    )
}
func generateOutfit(for weather: WeatherData) -> OutfitRecommendation {
    var tops = [String]()
    var bottoms = [String]()
    var outerwear = [String]()
    var footwear = [String]()
    var accessories = [String]()
    
    // Temperature rules
    switch weather.temperature {
    case ..<0:
        tops.append("Thermal shirt")
        outerwear.append("Heavy coat")
        bottoms.append("Lined trousers")
        footwear.append("Winter boots")
        accessories += ["Gloves", "Scarf", "Beanie"]
    case 0..<10:
        tops.append("Sweater")
        outerwear.append("Puffer jacket")
        bottoms.append("Jeans or warm pants")
        footwear.append("Boots")
        accessories += ["Scarf"]
    case 10..<18:
        tops.append("Long-sleeve shirt")
        outerwear.append("Light jacket")
        bottoms.append("Chinos or jeans")
        footwear.append("Sneakers")
    case 18..<24:
        tops.append("T-shirt or light long sleeve")
        bottoms.append("Jeans or skirt")
        outerwear.append("Cardigan or denim jacket")
        footwear.append("Sneakers or loafers")
    case 24..<30:
        tops.append("Short sleeve shirt or tank top")
        bottoms.append("Shorts or dress")
        footwear.append("Sandals or sneakers")
        accessories.append("Sunglasses")
    default:
        tops.append("Tank top")
        bottoms.append("Shorts or skirt")
        footwear.append("Sandals")
        accessories += ["Hat", "Sunglasses"]
    }
    
    // Rain rules
        if weather.precipitation > 0 {
            outerwear.append("Waterproof jacket")
            accessories.append("Umbrella")
            if weather.precipitation > 5 {
                footwear = ["Waterproof boots"]
            }
        }

        // Snow rules
        if weather.isSnowing {
            outerwear.append("Snow-proof coat")
            footwear = ["Insulated snow boots"]
            accessories += ["Gloves", "Scarf"]
        }

        // Wind rules
        if weather.windSpeed > 20 {
            outerwear.append("Windbreaker")
            accessories.append("Tie hair / secure layers")
        }

        // UV rules
        if weather.uvIndex >= 6 {
            accessories += ["Hat", "Sunscreen"]
        }

        return OutfitRecommendation(
            tops: tops,
            bottoms: bottoms,
            outerwear: outerwear,
            footwear: footwear,
            accessories: accessories
        )
    }
