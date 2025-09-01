// MARK: - Full-page story with brand gradient + white cards + logo
import SwiftUI

struct ShareableOutfitCard: View {
    var temperature: Int
    var icon: String
    var weatherMessage: String
    var outfitIcon: String
    var outfitTitle: String
    var outfitImage: String
    var tips: [String]
    var locationName: String
    var brandLogoName: String? = "dresscast_logo"
    var theme: WeatherTheme = .partlyCloudy   // change per conditions

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // BRAND GRADIENT
                theme.gradient

                VStack(spacing: 0) {

                    // Weather header (brand text colors)
                    VStack(alignment: .leading, spacing: w * 0.008) {
                        HStack(spacing: w * 0.02) {
                            Text(icon)
                                .font(.system(size: w * 0.05))
                            Text("\(temperature)°C in \(locationName)")
                                .font(.system(size: w * 0.05, weight: .bold))
                        }
                        Text(weatherMessage)
                            .font(.system(size: w * 0.035))
                            .foregroundStyle(.white.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, w * 0.06)
                    .padding(.top, h * 0.06)
                    .foregroundStyle(.white)

                    // Headline
                    HStack(alignment: .top, spacing: w * 0.02) {
                        if !outfitIcon.isEmpty {
                            Text(outfitIcon)
                                .font(.system(size: w * 0.08))
                                .padding(.top, w * 0.01)
                        }
                        Text(outfitTitle)
                            .font(.system(size: w * 0.09, weight: .heavy))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundStyle(.white)
                            .lineSpacing(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, w * 0.06)
                    .padding(.top, h * 0.015)

                    // Illustration card
                    ZStack {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Brand.cardLight)
                            .shadow(color: .black.opacity(0.16), radius: 18, y: 8)

                        Image(outfitImage)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, w * 0.08)
                            .padding(.vertical, h * 0.025)
                    }
                    .frame(width: w * 0.88, height: h * 0.37)
                    .padding(.top, h * 0.02)

                    // Tips card
                    VStack(alignment: .leading, spacing: h * 0.014) {
                        Text("Quick Tips")
                            .font(.system(size: w * 0.06, weight: .bold))
                            .foregroundStyle(Brand.textPrimaryLight)

                        VStack(alignment: .leading, spacing: h * 0.010) {
                            ForEach(Array(tips.enumerated()), id: \.offset) { _, tip in
                                HStack(alignment: .top, spacing: w * 0.02) {
                                    Circle()
                                        .fill(Brand.accent) // brand accent bullet
                                        .frame(width: w * 0.018, height: w * 0.018)
                                        .padding(.top, w * 0.018)
                                    Text(tip)
                                        .font(.system(size: w * 0.05))
                                        .foregroundStyle(Brand.textPrimaryLight)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                    .padding(.vertical, h * 0.02)
                    .padding(.horizontal, w * 0.05)
                    .frame(width: w * 0.88, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Brand.cardLight)
                            .shadow(color: .black.opacity(0.14), radius: 16, y: 6)
                    )
                    .padding(.top, h * 0.024)

                    Spacer(minLength: h * 0.02)

                    // Footer logo
                    VStack(spacing: h * 0.008) {
                        if let brandLogoName,
                           UIImage(named: brandLogoName) != nil {
                            Image(brandLogoName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: w * 0.22)
                                .shadow(color: .black.opacity(0.25), radius: 6, y: 2)
                        } else {
                            Text("DressCast")
                                .font(.system(size: w * 0.06, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.96))
                                .shadow(radius: 2)
                        }
                    }
                    .padding(.bottom, h * 0.04)
                }
            }
        }
        .frame(width: 1080, height: 1920) // story export size
    }
}



struct SharePayload: Identifiable {
    let id = UUID()
    let items: [Any]
}

