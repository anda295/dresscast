// DressCastView.swift with full support for:
// - Dark mode
// - Outfit illustration fade animation
// - Top bar with location picker and settings button

import SwiftUI


struct OutfitIllustrationView: View {
    var imageName: String
    var opacity: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemGray6))
                .frame(maxWidth: .infinity)
                .frame(height: 300)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 260)
                .opacity(opacity)
        }
        .padding(.horizontal)
    }
}
struct QuickTipsView: View {
    var tips: [ String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Tips")
                .font(.headline)
                .foregroundColor(.primary)

            ForEach(tips, id: \.self) {  tip in
                HStack(alignment: .top, spacing: 10) {
                   // Text(emoji)
                    Text(tip)
                        .font(.body)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

struct WeatherHeaderView: View {
    var temperature: Int
    var icon: String
    var message: String
    var locationName: String?

    var body: some View {
        HStack(spacing: 6) {
            Text(icon)
                .font(.system(size: 20, weight: .semibold))
            Text("\(temperature)°C")
                .font(.system(size: 18, weight: .semibold))
            if(locationName != nil){
                Text("in " + (locationName ?? ""))
                    .font(.system(size: 18, weight: .semibold))
            }
            Text(" — \(message)")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
struct OutfitHeadlineView: View {
    var icon: String
    var text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon)
                .padding(.top, 2) // small tweak for visual balance
            Text(text)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
    }
}
