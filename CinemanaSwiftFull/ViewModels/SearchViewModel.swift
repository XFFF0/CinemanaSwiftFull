import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""
    @Published var results: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func search() async {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            results = []
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            results = try await CinemaService.shared.search(query: text)
        } catch {
            errorMessage = error.localizedDescription
            results = []
        }

        isLoading = false
    }
}
