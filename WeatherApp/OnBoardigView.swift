//
//  OnBoardigView.swift
//  WeatherApp
//
//  Created by Alin Postolache on 06.08.2025.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - State
    @State private var page = 0
    @State private var gender: Gender?
    @State private var cold: ColdProfile?
    @State private var style: BroadStyle?
    
    // MARK: - Persistence (use elsewhere in app)
    @AppStorage("pref_gender") private var savedGender = ""
    @AppStorage("pref_cold")   private var savedCold   = ""
    @AppStorage("pref_style")  private var savedStyle  = ""
    @AppStorage("didOnboard") private var didOnboard = false

    var body: some View {
        VStack {
            TabView(selection: $page) {
                
                // ───────── Gender ─────────
                VStack(spacing: 24) {
                    Text("How do you identify?")
                        .font(.title2).bold()
                    
                    optionGrid(options: Gender.allCases,
                               selection: $gender) { option in          // ✨ explicit parameter
                        Text(option.label)                              // ✨ returns a View
                    }
                }
                .tag(0)
                
                // ───────── Cold tolerance ─────────
                VStack(spacing: 24) {
                    Text("How do you feel about cold?")
                        .font(.title2).bold()
                    optionList(options: ColdProfile.allCases,
                               selection: $cold) { Text($0.rawValue) }
                }
                .tag(1)
                
                // ───────── Broad style ─────────
                VStack(spacing: 24) {
                    Text("Pick your broad style")
                        .font(.title2).bold()
                    optionGrid(options: BroadStyle.allCases,
                               selection: $style) { option in
                        Text(option.label)
                    }
                    
                }
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(.easeInOut, value: page)
            
            // ───────── Next / Done button ─────────
            Button(action: next) {
                Text(page < 2 ? "Next" : "Get started")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(!canAdvance)
        }
        .padding(.top, 40)
    }
    
    // MARK: - Helpers
    private var canAdvance: Bool {
        switch page {
        case 0: return gender != nil
        case 1: return cold   != nil
        case 2: return style  != nil
        default: return false
        }
    }
    
    private func next() {
        if page < 2 {
            page += 1
        } else {
            // Save preferences
            savedGender = gender!.rawValue
            savedCold   = cold!.rawValue
            savedStyle  = style!.rawValue
            didOnboard  = true
        }
    }
    
    private func optionGrid<O: Identifiable, Content: View>(
        options: [O],
        selection: Binding<O?>,
        @ViewBuilder label: @escaping (O) -> Content
    ) -> some View {

        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        return LazyVGrid(columns: columns, spacing: 16) {    // ← explicit return
            ForEach(options) { option in
                label(option)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .padding()
                    .background(selection.wrappedValue?.id == option.id
                                ? Color.accentColor.opacity(0.2)
                                : Color.gray.opacity(0.15))
                    .cornerRadius(8)
                    .onTapGesture { selection.wrappedValue = option }
            }
        }
        .padding(.horizontal)
    }
    private func optionList<O: Identifiable, Content: View>(
        options: [O],
        selection: Binding<O?>,
        @ViewBuilder label: @escaping (O) -> Content
    ) -> some View {
        VStack(spacing: 12) {
            ForEach(options) { option in
                label(option)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selection.wrappedValue?.id == option.id
                                ? Color.accentColor.opacity(0.2)
                                : Color.gray.opacity(0.15))
                    .cornerRadius(8)
                    .onTapGesture { selection.wrappedValue = option }
            }
        }
        .padding(.horizontal)
    }
}
