//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Alin Postolache on 08.05.2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct WeatherAppApp: App {
//    init() {
//        MobileAds.shared.start(completionHandler: nil)
//      }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("didOnboard") private var didOnboard = false
     var body: some Scene {
             WindowGroup {
                 Group {
                     if didOnboard {
                         ContentView()          // ← your main experience
                         
                     } else {
                         OnboardingView()       // ← shown only once
                     }
                 }
                 .animation(.easeInOut, value: didOnboard)   // smooth swap
             }
         }
     
}
