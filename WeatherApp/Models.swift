//
//  Models.swift
//  WeatherApp
//
//  Created by Alin Postolache on 20.08.2025.
//
import SwiftUI
import Foundation
import FirebaseFirestoreSwift

struct ShopItemDTO: Codable, Identifiable {
    @DocumentID var id: String?
    let title: String
    let price: Double
    let brand: String
    let imageUrl: String
    let deeplink: String?
    let sort: Int?
}

struct OutfitDoc: Codable {
    let title: String?
    let updatedAt: Date?
}


struct ShopItem: Identifiable, Hashable {
    let id: String
    let title: String
    let price: Double
    let brand: String
    let imageUrl: URL?
    let deeplink: URL?

    init(dto: ShopItemDTO) {
        self.id = dto.id ?? UUID().uuidString
        self.title = dto.title
        self.price = dto.price
        self.brand = dto.brand
        self.imageUrl = URL(string: dto.imageUrl)
        self.deeplink = dto.deeplink.flatMap(URL.init(string:))
    }
}
