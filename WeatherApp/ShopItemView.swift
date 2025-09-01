//
//  ShopItemView.swift
//  WeatherApp
//
//  Created by Alin Postolache on 19.08.2025.
//

import SwiftUI
struct ShopItem1: Identifiable, Hashable {
    let id = UUID()
    let imageName: String      // asset name (PNG) or SF Symbol
    let title: String
    let price: Double
    let brand: String
    let deeplink: URL? = nil   // optional
    let isSymbol: Bool = true // true if using SF Symbol
}
struct ShopCard: View {
   let item: ShopItem1

   var body: some View {
       VStack(spacing: 6) { // ↓ smaller spacing
           ZStack {
               RoundedRectangle(cornerRadius: 12) // ↓ corner radius
                   .fill(Color(UIColor.systemGray6))
               Group {
                   if item.isSymbol {
                       Image(systemName: item.imageName)
                           .resizable().scaledToFit().padding(16) // ↓ padding
                   } else {
                       Image(item.imageName)
                           .resizable().scaledToFit().padding(10) // ↓ padding
                   }
               }
           }
           .frame(width: 56, height: 56) // ↓ 80 → 56 (30% smaller)

           Text(item.title)
               .font(.system(size: 12, weight: .semibold)) // ↓ 16 → 12
               .foregroundColor(.primary)
               .lineLimit(1)

           Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
               .font(.system(size: 11, weight: .semibold)) // ↓ 15 → 11

           Text(item.brand)
               .font(.system(size: 10)) // ↓ 14 → 10
               .foregroundStyle(.secondary)
               .lineLimit(1)
       }
       .frame(width: 95) // ↓ 136 → 95
       .accessibilityElement(children: .combine)
   }
}

struct ShopTheLookSection: View {
   let items: [ShopItem1]
   var onSeeAll: (() -> Void)? = nil

   var body: some View {
       VStack(alignment: .leading, spacing: 8) { // ↓ 12 → 8
           HStack {
               HStack(spacing: 6) { // ↓ 8 → 6
                   Text("✨")
                   Text("Shop the Look")
                       .font(.system(size: 16, weight: .bold)) // ↓ 22 → 16
               }
               Spacer()
               if let onSeeAll {
                   Button(action: onSeeAll) {
                       Image(systemName: "chevron.right")
                           .font(.system(size: 12, weight: .semibold)) // ↓ 17 → 12
                   }
                   .buttonStyle(.plain)
                   .accessibilityLabel("See all")
               }
           }
           .padding(.horizontal)

           ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 10) { // ↓ 14 → 10
                   ForEach(items) { item in
                       ShopCard(item: item)
                   }
               }
               .padding(.horizontal)
           }
       }
       .padding(.top, 2)
   }
}
