//
//  ContentView.swift
//  WeatherApp
//
//  Created by Alin Postolache on 08.05.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var shareImage: UIImage?
    @State private var showShare = false
    @StateObject private var locationManager = LocationManager()
    @State private var sharePayload: SharePayload?

    @State private var showSettings = false

    @StateObject private var locationVM :LocationPickerViewModel
   @State private var outfit: OutfitDetails?
   @State private var loading = true
   @State private var error: String?
    @State private var showSearch = false
    @State private var lastFetchedLocation: LocationOption?
    @AppStorage("pref_gender") private var gender  = ""
    @AppStorage("pref_cold") private var coldRaw = ""
    @AppStorage("pref_style")  private var style   = ""
    @State private var showLocationPicker = false

    // Example usage:
    
    @State private var hasFetched = false
    init() {
           // Wire the shared manager into the view-model
           let lm = LocationManager()
           _locationManager = StateObject(wrappedValue: lm)
           _locationVM      = StateObject(wrappedValue: LocationPickerViewModel(locationManager: lm))
       }
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // MARK: - Top Bar
                HStack {
                        Picker("Location", selection: $locationVM.selected) {
                            ForEach(locationVM.options) { option in
                                Text(option.name).tag(Optional(option))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Button {
                            showSearch = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Add city")
                    Button {
                        Task { await shareForecastCard() }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(outfit == nil)
                    .accessibilityLabel("Share")
                    Spacer()

                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title3)
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView{
                            fetch() // 👈 this is passed into SettingsView as onSave
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
               
                
                
                // ───── Content
                if loading {
                    ProgressView("Loading outfit…")
                        .frame(maxHeight: .infinity, alignment: .center)
                } else if let outfit = outfit {
                    
                    ForecastFitView(outfitTitle:       outfit.title,
                                    shortWeatherInfo:  outfit.shortWeatherInfo,
                                    outfitName:        outfit.fashionType,
                                    tips: outfit.tips,
                                    icon:outfit.weatherIcon,
                                    temperature: outfit.temperature)
                    .transition(.opacity)
                } else if let error = error {
                    Text(error).foregroundColor(.red)
                } else {
                    EmptyView()       // first launch placeholder
                }
            }
         
//
            
            .onChange(of: locationVM.selected) { newValue in
                if let newValue, newValue != lastFetchedLocation {
                    lastFetchedLocation = newValue
                    fetch()
                    
                }
            }
            .onAppear {
                if !hasFetched, let selected = locationVM.selected {
                    hasFetched = true
                    lastFetchedLocation = selected
                    fetch()
                }
            }
            .sheet(isPresented: $showSearch) {
                LocationSearchSheet { newOption in
                    // Avoid duplicates
                    if !locationVM.options.contains(newOption) {
                        locationVM.options.append(newOption)
                    }
                    locationVM.selected = newOption
                }
            }.sheet(item: $sharePayload, onDismiss: { sharePayload = nil }) { payload in
                ShareSheet(items: payload.items)
            
            }
        }
        
    }
    @MainActor
    private func shareForecastCard() {
        guard let outfit else { return }
  
        let story = ShareableOutfitStory(
               temperature: outfit.temperature,
               icon: outfit.weatherIcon, // or from your weather data
               weatherMessage: outfit.shortWeatherInfo,
               outfitIcon: "",
               outfitTitle: outfit.title,
               outfitImage: outfit.fashionType,
               tips: outfit.tips,
               locationName:locationVM.selected?.name ?? "",
               theme:outfit.theme
           )
  

        
        let ui = story.renderedImage(width: 1080, height: 1920, background: .clear, scale: 1)

          // JPEG ~2–3MB
          guard let jpeg = ui.jpegData(compressionQuality: 0.9) else { return }


        sharePayload = SharePayload(items: [jpeg])
    }


   // MARK: – Data Pipeline
   private func fetch() {
       
       print ("FETCH")
       guard let option = locationVM.selected else { return }
       loading = true
       error   = nil
       
       fetchDetailedWeather(lat:option.coordinate.coordinate.latitude, lon: option.coordinate.coordinate.longitude) { weather in
           guard let weather = weather else {
               print("❌ Failed to get weather")
               return
           }
           let userColdProfile = ColdProfile(rawValue: coldRaw) ?? .neutral

           let preferredStyle      = BroadStyle(rawValue: style) ?? .casual
           let gender      = Gender(rawValue: gender) ?? .female
           let description = generateOutfitText(for: weather,coldProfile: userColdProfile,gender:gender, style:preferredStyle)
           let fullString = description.subheadline
           var icon = ""
           var text = ""
           if let firstSpaceIndex = fullString.firstIndex(where: { $0.isWhitespace }) {
                icon = String(fullString[..<firstSpaceIndex])
                text = fullString[firstSpaceIndex...].trimmingCharacters(in: .whitespaces)
           }
           let details = OutfitDetails(title: description.headline, shortWeatherInfo: text, fashionType: description.imageName, tips: description.tips,temperature: description.temperature,weatherIcon: icon,
                                                    theme:description.themeForShare)
           DispatchQueue.main.async {
               self.outfit  = details
               self.loading = false
               return
           }
       }

   }
}

