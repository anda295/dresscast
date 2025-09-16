import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitId: String
    let width: CGFloat

    func makeUIView(context: Context) -> BannerView {
        let size = currentOrientationAnchoredAdaptiveBanner(width: width)
        let banner = BannerView(adSize: size)
        banner.adUnitID = adUnitId
        banner.rootViewController = topVC()
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        let size = currentOrientationAnchoredAdaptiveBanner(width: width)
        if uiView.adSize.size.width != size.size.width {
            uiView.adSize = size
            uiView.load(Request())
        }
        uiView.rootViewController = topVC()
    }

    private func topVC(base: UIViewController? = {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    }()) -> UIViewController? {
        if let nav = base as? UINavigationController { return topVC(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController { return topVC(base: tab.selectedViewController) }
        if let presented = base?.presentedViewController { return topVC(base: presented) }
        return base
    }
}
