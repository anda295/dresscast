//
//  Service.swift
//  WeatherApp
//
//  Created by Alin Postolache on 19.08.2025.
//

import Foundation
// MARK: - Style-specific tip pools (extend anytime)
struct StyleTips {
    struct Casual {
        static let general = [
            "👟 Comfy sneakers pair with almost anything.",
            "🧥 Denim or a light bomber keeps it easy.",
            "🎒 Throw a tote/mini backpack for layers."
        ]
        static let rain = [
            "🧥 Go for a light shell over hoodie.",
            "🧼 Skip suede; canvas or synthetics are safer."
        ]
        static let cold = [
            "🧣 Knit scarf adds warmth without fuss.",
            "🧢 Beanie over hoodie = extra cozy."
        ]
        static let chill = [
            "🧥 Light jacket over a tee works great.",
            "🧤 Thin gloves if you run cold."
        ]
        static let hot = [
            "🧵 Choose loose cottons/linens.",
            "🧢 Cap + breathable tee keeps it casual."
        ]
        static let uv = [
            "🕶️ Shades and light colors help.",
            "🧴 Pocket sunscreen never hurts."
        ]
        static let wind = [
            "💨 Windbreaker layers cleanly over basics."
        ]
        static let snow = [
            "🥾 Lug soles beat ice patches."
        ]
    }

    struct Sporty {
        static let general = [
            "🎽 Moisture‑wicking base keeps you comfy.",
            "👟 Cushioned trainers for all‑day wear."
        ]
        static let rain = [
            "🧥 Water‑resistant shell over performance fleece.",
            "🧼 Quick‑dry fabrics > cotton today."
        ]
        static let cold = [
            "🧊 Thermal leggings under joggers.",
            "🧤 Tech gloves keep fingers nimble."
        ]
        static let chill = [
            "🏃 Light mid‑layer under a shell.",
            "🧢 Ear‑covering beanie helps a lot."
        ]
        static let hot = [
            "💧 Mesh top + shorts; hydrate.",
            "🧢 Performance cap + airy socks."
        ]
        static let uv = [
            "🧴 SPF and UV sleeves if outside.",
            "🕶️ Sport shades cut glare."
        ]
        static let wind = [
            "💨 Packable windbreaker = clutch."
        ]
        static let snow = [
            "🥾 Traction soles; avoid knit uppers."
        ]
    }

    struct Elegant {
        static let general = [
            "🧵 Keep lines clean; fewer bulky layers.",
            "👜 Minimal accessories elevate the look."
        ]
        static let rain = [
            "☔ Umbrella + trench read polished.",
            "🧼 Avoid suede; treated leather is safer."
        ]
        static let cold = [
            "🧣 Fine wool scarf under a tailored coat.",
            "🧤 Leather gloves keep it sharp."
        ]
        static let chill = [
            "🧥 Light wool or soft trench layers smartly.",
            "👞 Polished shoes finish the outfit."
        ]
        static let hot = [
            "🧵 Linen or TENCEL keep structure without heat.",
            "🕶️ Slim shades + light palette = crisp."
        ]
        static let uv = [
            "👒 Consider a brimmed hat with clean lines.",
            "🧴 Invisible SPF to protect fabrics & skin."
        ]
        static let wind = [
            "💨 Choose a belted coat to keep shape."
        ]
        static let snow = [
            "🥾 Rubber‑soled leather; condition after."
        ]
    }
}

enum TempBand {
    case below0
    case zeroTo10
    case tenTo18Rain
    case tenTo18Dry
    case eighteenTo24
    case twenty4To30
    case over30
}
func band(for feels: Double, precipitation: Double) -> TempBand {
    switch feels {
    case ..<0:          return .below0
    case 0..<10:        return .zeroTo10
    case 10..<18:       return precipitation > 0 ? .tenTo18Rain : .tenTo18Dry
    case 18..<24:       return .eighteenTo24
    case 24..<30:       return .twenty4To30
    default:            return .over30
    }
}
struct HeadlineLibrary {

    // MARK: Neutral (style‑agnostic)
    static let neutral: [TempBand: [String]] = [
        .below0: [
            "🧣 Heavy coat and boots kind of day.",
            "🥶 Frostbite fashion: bundle up and brave it.",
            "🧊 Freezer levels of cold — full layers required.",
            "❄️ Winter’s not playing — go full cozy mode.",
            "🌬️ Double scarf weather.",
            "🥾 Snow crunch + ice patches — dress sturdy.",
            "🧤 Gloves aren’t optional today.",
            "🥶 Nose-numbing temps — thermal everything."
        ],
        .zeroTo10: [
            "🧥 Definitely coat weather.",
            "🥶 Slightly less frozen — still layer up.",
            "🧣 Cold breeze day — bundle smartly.",
            "🧤 Cool enough to justify a thick jacket.",
            "🧢 Beanie season continues.",
            "🧥 Puffer jacket prime time.",
            "🥾 Boots and jeans make sense today.",
            "❄️ Chilly air calls for layers on layers."
        ],
        .tenTo18Rain: [
            "🧥 It’s a trench and sneakers kind of day.",
            "🌧️ Casual rainy day layering.",
            "🧢 Hoodie + shell = winning combo.",
            "🧥 Drizzly chic? Layer up light.",
            "🌂 Bring your umbrella game strong.",
            "🌦️ Misty skies = perfect trench coat.",
            "🧥 Shell jacket + trainers = sorted.",
            "☔ A raincoat saves the day."
        ],
        .tenTo18Dry: [
            "🧢 Throw on a light jacket and go.",
            "🧥 Crisp air, clean look day.",
            "🧣 Stylish sweater weather.",
            "🧥 Add a hoodie and own the chill.",
            "👟 Denim jacket energy.",
            "🍂 Feels like autumn, dress like it.",
            "🧢 Baseball cap + hoodie = casual win.",
            "🧥 Bomber jacket season."
        ],
        .eighteenTo24: [
            "👕 Perfect day for jeans and a tee.",
            "🧢 Mild and manageable.",
            "👖 Great day to dress light and comfy.",
            "👕 Comfort-core weather. Lean in.",
            "☀️ Light jacket optional.",
            "👟 Tee + sneakers = classic combo.",
            "🌤️ Balanced weather = balanced outfit.",
            "🧥 Cardigan on standby kind of day."
        ],
        .twenty4To30: [
            "🩳 Short sleeves are your friend today.",
            "🧢 Sunglasses + tee weather.",
            "☀️ Feel the warmth — dress light.",
            "🕶️ Go breezy, stay cool.",
            "👟 Shorts + sneakers all day.",
            "🌞 Light colors keep it chill.",
            "🩳 Time to show some ankle.",
            "🧢 Baseball cap + shorts = summer vibe."
        ],
        .over30: [
            "🔥 Minimal clothing. Max hydration.",
            "🌞 Barely legal to wear pants.",
            "🥵 It’s melt season — dress smart.",
            "💧 Avoid heat stroke — think airflow.",
            "🧢 Cap + tank top weather.",
            "🩳 Shorts mandatory, jeans forbidden.",
            "🕶️ Shade is your best accessory.",
            "☀️ Sunscreen is basically an outfit."
        ]
    ]

    // MARK: Style overlays — just add more lines per band as you like

    static let casual: [TempBand: [String]] = [
        .tenTo18Dry: [
            "🧥 Flannel + light jacket day.",
            "👟 Hoodie weather, finally."
        ],
        .eighteenTo24: [
            "👕 Tee, jeans, done.",
            "🧢 Casual cap kind of day."
        ],
        .twenty4To30: [
            "🩳 Shorts + loose tee = winning."
        ]
    ]

    static let sporty: [TempBand: [String]] = [
        .tenTo18Dry: [
            "🏃‍♂️ Track jacket and joggers energy.",
            "🎽 Layer a performance tee under."
        ],
        .eighteenTo24: [
            "🏃 Breathable tee + lightweight joggers.",
            "👟 Athleisure weather — go comfy."
        ],
        .twenty4To30: [
            "🎽 Mesh top + running shorts all day."
        ],
        .over30: [
            "💦 Train early — heat is real."
        ]
    ]

    static let elegant: [TempBand: [String]] = [
        .tenTo18Rain: [
            "🧥 Trench, pressed chinos — sleek in drizzle.",
            "☔ Umbrella meets polished layers."
        ],
        .tenTo18Dry: [
            "🧣 Fine knit + tailored coat.",
            "🧥 Light wool and clean lines."
        ],
        .eighteenTo24: [
            "👔 Crisp shirt with light trousers.",
            "🧥 Unstructured blazer optional."
        ],
        .twenty4To30: [
            "🕶️ Linen shirt and airy tailoring."
        ],
        .over30: [
            "🌞 Resort-cool: linen everything."
        ]
    ]

    // MARK: Gender nudges (optional)
    // Keep these short; they are appended, not replaced.
    static let femaleNudges: [TempBand: [String]] = [
        .eighteenTo24: ["👡 Light dress + cardigan works too."]
    ]
    static let maleNudges: [TempBand: [String]] = [
        .eighteenTo24: ["👞 Loafers dress it up without heat."]
    ]

    // MARK: API — fetch merged pool for a band/gender/style
    static func pool(for band: TempBand,
                     gender: Gender,
                     style: BroadStyle) -> [String] {
        var result = neutral[band] ?? []

        switch style {
        case .casual:   result += casual[band]  ?? []
        case .sporty:   result += sporty[band]  ?? []
        case .elegant:  result += elegant[band] ?? []
        default:  result += casual[band]  ?? []
        }

        // Gentle gender nudges
        switch gender {
        case .female: result += femaleNudges[band] ?? []
        case .male:   result += maleNudges[band]   ?? []
        default : result += femaleNudges[band] ?? []
      //  case .other:  break
        }

        // Final fallback (should never be empty)
        if result.isEmpty { result = neutral[band] ?? ["🌤️ Dress for comfort."] }
        return Array(Set(result))  // de‑dupe
    }
}
func styleSources(for style: BroadStyle,
                          feels: Double,
                          weather: WeatherData) -> [[String]] {
    // Choose the style namespace
    let S: (general: [String], rain: [String], cold: [String], chill: [String], hot: [String], uv: [String], wind: [String], snow: [String]) = {
        switch style {
        case .casual:  return (StyleTips.Casual.general, StyleTips.Casual.rain, StyleTips.Casual.cold, StyleTips.Casual.chill, StyleTips.Casual.hot, StyleTips.Casual.uv, StyleTips.Casual.wind, StyleTips.Casual.snow)
        case .sporty:  return (StyleTips.Sporty.general, StyleTips.Sporty.rain, StyleTips.Sporty.cold, StyleTips.Sporty.chill, StyleTips.Sporty.hot, StyleTips.Sporty.uv, StyleTips.Sporty.wind, StyleTips.Sporty.snow)
        case .elegant: return (StyleTips.Elegant.general, StyleTips.Elegant.rain, StyleTips.Elegant.cold, StyleTips.Elegant.chill, StyleTips.Elegant.hot, StyleTips.Elegant.uv, StyleTips.Elegant.wind, StyleTips.Elegant.snow)
        default: return (StyleTips.Casual.general, StyleTips.Casual.rain, StyleTips.Casual.cold, StyleTips.Casual.chill, StyleTips.Casual.hot, StyleTips.Casual.uv, StyleTips.Casual.wind, StyleTips.Casual.snow)
        }
    }()

    var result: [[String]] = []

    // Condition-priority (style-first)
    if weather.precipitation > 0 { result.append(S.rain) }
    if weather.isSnowing          { result.append(S.snow) }
    if weather.windSpeed > 20     { result.append(S.wind) }
    if weather.uvIndex > 6        { result.append(S.uv) }

    if feels < 0       { result.append(S.cold) }
    else if feels < 10 { result.append(S.chill) }
    else if feels > 30 { result.append(S.hot) }

    // Always include general style tips last
    result.append(S.general)
    return result
}
