import SwiftUI
import Combine
enum TimeoutError: Error { case timeout }

func withTimeout<T>(
    _ seconds: Double,
    _ opName: String,
    operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask { try await operation() }
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw TimeoutError.timeout
        }
        let result = try await group.next()!
        group.cancelAll()
        return result
    }
}
@MainActor
final class ForecastFitVM: ObservableObject {
    @Published var items: [ShopItem] = []
    @Published var imgUrl: String = ""
    @Published var isLoading = false
    @Published var error: String?

    private let service = ShopService()

    func loadAll(imageName: String) {
        print("loadAll called with:", imageName)
        isLoading = true
        error = nil

        Task {
            do {
                print("→ fetching outfitDoc…")
                let doc = try await withTimeout(15, "outfitDoc") { [self] in
                    try await self.service.fetchOutfitDoc(for: imageName)
                }
                print("✓ outfitDoc fetched (imgUrl: \(doc?.imgUrl ?? "nil"))")

                print("→ fetching shopItems…")
                let items = try await withTimeout(15, "shopItems") {
                    try await self.service.fetchShopItems(for: imageName)
                }
                print("✓ shopItems fetched: \(items.count)")

                self.imgUrl = doc?.imgUrl ?? ""
                self.items  = items
                self.isLoading = false
            } catch {
                self.error = String(describing: error)
                print("✗ loadAll error:", self.error ?? "")
                self.imgUrl = ""
                self.items = []
                self.isLoading = false
            }
        }
    }

}
