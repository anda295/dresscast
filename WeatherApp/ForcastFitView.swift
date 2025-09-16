import SwiftUI

struct ForecastFitView: View {
    var outfitTitle : String
    var shortWeatherInfo : String
    var outfitName : String
    var tips:[String]
    var icon : String
    var temperature : Int
    @StateObject private var vm = ForecastFitVM()

    // demo data
    var shopItems: [ShopItem1] = [
        ShopItem1(imageName: "tshirt", title: "White Tee", price: 19, brand: "Zara"),
        ShopItem1(imageName: "pants",  title: "Wide Pants", price: 35, brand: "H&M"),
        ShopItem1(imageName: "shoe",   title: "Adidas Sneakers", price: 85, brand: "Adidas"),
        ShopItem1(imageName: "bag",    title: "Tote Bag", price: 29, brand: "COS"),
        ShopItem1(imageName: "cap",    title: "Cap", price: 15, brand: "Uniqlo")
    ]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // your scrolling content
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 24) {
                        
                        WeatherHeaderView(
                            temperature: temperature,
                            icon: icon,
                            message: shortWeatherInfo,
                            locationName: nil
                        )
                        
                        OutfitHeadlineView(icon: "", text: outfitTitle)
                       OutfitIllustrationView(imageUrlString: vm.imgUrl, opacity: 0.9)
                        
                        ShopTheLookRemoteSection(vm: vm) // inject shared VM
                        
                        QuickTipsView(tips: tips).frame(width: geo.size.width)
                        
                        Spacer(minLength: 24) // bottom breathing room
                    }   // unified safe margins
                    // .padding(.horizontal, 16)
                    //.padding(.top, 8) // additional top offset if you want a bit more space
                    BannerAdView(
                                        adUnitId: "ca-app-pub-3940256099942544/2934735716",
                                        width: geo.size.width - 32
                                    )
                                    .padding(.horizontal, 16)
//                    .background(Color(.systemBackground))

                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea(.keyboard) // keep layout steady when keyboard appears
            
            }.task(id: outfitName) {
                vm.loadAll(imageName: outfitName)
            }
        }
    }
}
