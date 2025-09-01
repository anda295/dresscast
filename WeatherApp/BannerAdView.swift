//
//  BannerAdView.swift
//  WeatherApp
//
//  Created by Alin Postolache on 01.09.2025.
//

// BannerAdView.swift
import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    /// Use a TEST unit while developing:
    /// iOS banner test: ca-app-pub-3940256099942544/2934735716
    let adUnitId: String
    /// The width the banner should adapt to (usually the screen width minus padding)
    let width: CGFloat

    func makeUIView(context: Context) -> BannerView {
        let size = currentOrientationAnchoredAdaptiveBanner(width: width)
        let banner = BannerView(adSize: size)
        banner.adUnitID = adUnitId
        banner.rootViewController = BannerAdView.topViewController()
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        // Recompute size if width changes (rotation, iPad split, etc.)
        let newSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        if uiView.adSize.size.width != newSize.size.width {
            uiView.adSize = newSize
            // Optional: reload when size changes
            uiView.load(Request())
        }
        // Root VC can change if scenes change; keep it fresh
        uiView.rootViewController = BannerAdView.topViewController()
    }

    // Safely resolve the current top view controller
    private static func topViewController(base: UIViewController? = {
        // iOS 13+ scene-based approach
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    }()) -> UIViewController? {
        if let nav = base as? UINavigationController { return topViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController { return topViewController(base: tab.selectedViewController) }
        if let presented = base?.presentedViewController { return topViewController(base: presented) }
        return base
    }
}
