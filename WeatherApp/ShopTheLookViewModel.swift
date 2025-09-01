import SwiftUI
import Combine

@MainActor
final class ShopTheLookViewModel: ObservableObject {
    @Published var items: [ShopItem] = []
    @Published var isLoading = false
    @Published var error: String?

    private let service = ShopService()

    func load(imageName: String) {
        print(imageName)
        print("Load")
        Task {
            isLoading = true
            error = nil
            do {
                let fetched = try await service.fetchShopItems(for: imageName)
                self.items = fetched
                print("PRINT")
                print(self.items.count)
            } catch {
                self.error = error.localizedDescription
                self.items = []   // keep empty, ForecastFitView can show fallback
            }
            isLoading = false
        }
    }
}
