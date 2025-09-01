//
//  ShopTheLookRemoteSectionView.swift
//  WeatherApp
//
//  Created by Alin Postolache on 20.08.2025.
//

import SwiftUI

struct ShopTheLookRemoteSection: View {
    @StateObject private var vm = ShopTheLookViewModel()
    let illustrationName: String
    var onSeeAll: (() -> Void)? = nil
    var fallback: [ShopItem] = []   // optional local defaults

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Text("✨")
                    Text("Shop the Look")
                        .font(.system(size: 18, weight: .bold))
                }
                Spacer()
                if let onSeeAll {
                    Button(action: onSeeAll) {
                        Image(systemName: "chevron.right").font(.system(size: 15, weight: .semibold))
                    }.buttonStyle(.plain)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    if vm.isLoading {
                        ForEach(0..<4) { _ in
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(UIColor.systemGray6))
                                .frame(width: 80, height: 80)
                                .redacted(reason: .placeholder)
                        }
                    } else if !vm.items.isEmpty {
                        ForEach(vm.items) { item in
                            RemoteShopCard(item: item)
                        }
                    } else {
                        // fallback (optional)
                        ForEach(fallback) { item in
                            RemoteShopCard(item: item)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear { vm.load(imageName: illustrationName) }
        .onChange(of: illustrationName) { new in vm.load(imageName: new) }
        .padding(.top, 4)
    }
}
