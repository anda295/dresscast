//
//  SuggestionView.swift
//  WeatherApp
//
//  Created by Alin Postolache on 08.05.2025.
//

import SwiftUI

struct SuggestionButton: View {
   // var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 8) {
           // Image(systemName: icon)
            Text(text)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }
}
struct SuggestionPill: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(text).truncationMode(.middle)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct VibeButton: View {
    var title: String
    
    var body: some View {
        Text(title)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
    }
}
