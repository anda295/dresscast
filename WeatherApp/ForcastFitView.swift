import SwiftUI
import GoogleMobileAds

struct ForecastFitView: View {
    var outfitTitle : String
    var shortWeatherInfo : String
    var outfitName : String
    var tips:[String]
    var icon : String
    var temperature : Int

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
                        
                        OutfitIllustrationView(imageName: outfitName, opacity: 0.9)
                                                ShopTheLookRemoteSection(
                            illustrationName: outfitName,
                            onSeeAll: {
                                // push a grid with all items for this illustration
                            },
                            fallback: []
                        )
                        
                        QuickTipsView(tips: tips)
                        
                        Spacer(minLength: 24) // bottom breathing room
                    }
                    // unified safe margins
                    // .padding(.horizontal, 16)
                    //.padding(.top, 8) // additional top offset if you want a bit more space
                    BannerAdView(
                        adUnitId: "ca-app-pub-3940256099942544/2934735716", // TEST iOS banner
                        width: geo.size.width
                    )
                    .background(Color(.systemBackground))

                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea(.keyboard) // keep layout steady when keyboard appears
                // In iOS 17+, you could use this instead of manual horizontal padding:
                // .contentMargins(.horizontal, 16, for: .scrollContent)
            }
        }
    }
}
