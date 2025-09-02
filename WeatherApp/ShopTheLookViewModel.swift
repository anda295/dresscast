import SwiftUI
import Combine

@MainActor
final class ShopTheLookViewModel: ObservableObject {
    @Published var items: [ShopItem] = []
    @Published var isLoading = false
    @Published var isLoadingImgUrl = false

    @Published var error: String?
    @Published var imgUrl: String = ""
    private let service = ShopService()
    func loadImgUrl(imageName: String) {
        Task {
            isLoadingImgUrl = true
            error = nil
            do {
                let fetched = try await service.fetchOutfitDoc(for: imageName)
                self.imgUrl = fetched?.imgUrl ?? ""
            
            } catch {
                self.error = error.localizedDescription
                self.imgUrl = ""   // keep empty, ForecastFitView can show fallback
            }
            isLoadingImgUrl = false
        }
    }
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
                print(self.items[0].title)
            } catch {
                self.error = error.localizedDescription
                self.items = []   // keep empty, ForecastFitView can show fallback
            }
            isLoading = false
        }
    }
}
