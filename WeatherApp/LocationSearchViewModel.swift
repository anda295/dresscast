import MapKit
import Combine
import CoreLocation

@MainActor
final class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {

    // Published to the view
    @Published var query            = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []
    @Published var isSearching      = false
    @Published var errorMessage: String?

    private let completer = MKLocalSearchCompleter()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address

        // Every time the query string changes we feed it to the completer
        $query
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.completer.queryFragment = text
            }
            .store(in: &cancellables)
    }

    // MARK: - MKLocalSearchCompleterDelegate
    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            suggestions = completer.results
        }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter,
                               didFailWithError error: Error) {
        Task { @MainActor in
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Resolve a completion into a CLLocation
    func location(for completion: MKLocalSearchCompletion) async throws -> CLLocation {
        let request = MKLocalSearch.Request(completion: completion)
        let response = try await MKLocalSearch(request: request).start()
        guard let coordinate = response.mapItems.first?.placemark.coordinate else {
            throw URLError(.badServerResponse)
        }
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
