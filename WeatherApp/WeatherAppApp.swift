//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Alin Postolache on 08.05.2025.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds
import UserMessagingPlatform
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct WeatherAppApp: App {
    init() {
           // 1) Request consent (EU/EEA) – non-blocking
        ConsentInformation.shared.requestConsentInfoUpdate(with: RequestParameters()) { error in
               if error == nil {
                   // If required, present the consent form
                   if ConsentInformation.shared.formStatus == .available {
                       ConsentForm.load { form, error in
                           if let form = form {
                               form.present(from: nil) { _ in
                                   // After form, you can (re)start ads
                                   MobileAds.shared.start(completionHandler: nil)
                               }
                           } else {
                               MobileAds.shared.start(completionHandler: nil)
                           }
                       }
                   } else {
                       MobileAds.shared.start(completionHandler: nil)
                   }
               } else {
                   // If consent fetch fails, still start ads (you may choose to defer)
                   MobileAds.shared.start(completionHandler: nil)
               }
           }
       }

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
