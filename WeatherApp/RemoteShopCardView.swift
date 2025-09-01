import SwiftUI

struct RemoteShopCard: View {
    let item: ShopItem

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemGray6))

                if let url = item.imageUrl {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable()
                                .scaledToFit()
                                .padding(4) // ↓ much smaller padding, fills more
                        case .failure(_):
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .padding(8) // ↓ from 16 → 8
                                .foregroundColor(.secondary)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(8) // ↓ from 16 → 8
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 84, height: 84) // ↑ make it square, gives more room

            Text(item.title)
                .font(.system(size: 11, weight: .semibold))
                .lineLimit(1)

            Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: 11, weight: .semibold))

            if let url = item.deeplink {
                Link(item.brand, destination: url)
                    .font(.system(size: 10))
                    .foregroundStyle(.blue)
                    .lineLimit(1)
            } else {
                Text(item.brand)
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 95)
        .accessibilityElement(children: .combine)
    }
}
