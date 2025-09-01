import SwiftUI
import CoreLocation
import MapKit

struct LocationSearchSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm = LocationSearchViewModel()

    /// Pass the final choice back to whoever presented the sheet
    var onSelect: (LocationOption) -> Void

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.suggestions, id: \.self) { completion in
                    VStack(alignment: .leading) {
                        Text(completion.title).font(.headline)
                        Text(completion.subtitle).font(.subheadline).foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { select(completion) }
                }
            }
            .overlay {
                if vm.query.isEmpty {
                   // ContentUnavailableView("Search for a city or address")
                    Text("Search for a city or address")
                } else if vm.suggestions.isEmpty {
                    Text("No matches")
                }
            }
            .navigationTitle("Add City")
            .searchable(text: $vm.query, prompt: "City or address")
            .toolbar { ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }}
        }
    }

    private func select(_ completion: MKLocalSearchCompletion) {
        Task {
            do {
                let loc = try await vm.location(for: completion)
                let option = LocationOption(name: completion.title, coordinate: loc)
                onSelect(option)
                dismiss()
            } catch {
                // very small chance of lookup failure
            }
        }
    }
}
