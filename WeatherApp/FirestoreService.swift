//
//  FirestoreService.swift
//  WeatherApp
//
//  Created by Alin Postolache on 20.08.2025.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ShopService {
    private let db = Firestore.firestore()

    /// Fetch shop items for an illustration name (imageName)
    func fetchShopItems(for imageName: String) async throws -> [ShopItem] {
        let base = db.collection("outfits").document(imageName)
        let snap = try await base.collection("shopItems")
            .order(by: "sort", descending: false)
            .getDocuments()
     //   print(base.value(forKey: "title"))
       // print(base.value(forKey: "shopItems"))
        print(snap.count)
        let items = try snap.documents.compactMap { doc -> ShopItem? in
            let dto = try doc.data(as: ShopItemDTO.self)
            return ShopItem(dto: dto)
        }
        return items
    }

    /// (Optional) Fetch outfit doc (e.g., to override headline later)
    func fetchOutfitDoc(for imageName: String) async throws -> OutfitDoc? {
        let doc = try await db.collection("outfits").document(imageName).getDocument()
        return try doc.data(as: OutfitDoc.self)
    }
}
