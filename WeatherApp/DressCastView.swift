// DressCastView.swift with full support for:
// - Dark mode
// - Outfit illustration fade animation
// - Top bar with location picker and settings button

import SwiftUI

// Simple image view that just renders the URL
struct OutfitIllustrationView: View {
    let imageUrlString: String
    let opacity: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemGray6))
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .padding(.leading,20)
                .padding(.trailing,20)
            if let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(height: 260)
                    case .success(let image):
                        image.resizable().scaledToFit()
                            .frame(height: 260)
                            .opacity(opacity)
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable().scaledToFit()
                            .frame(height: 260)
                            .foregroundColor(.secondary)
                            .opacity(opacity)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct QuickTipsView: View {
    var tips: [ String]

    var body: some View {
        VStack(alignment: .leading) {
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
        .frame(maxWidth: .infinity)
        .padding(.leading,20)
        .padding(.trailing,20)
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
        .padding(.leading,10)
        .padding(.trailing,10)
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
        }.padding(.leading,10).padding(.trailing,10)
    }
}
