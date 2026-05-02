import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var banners: [Movie] = []
    @Published var latest: [Movie] = []
    @Published var groups: [VideoGroup] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil

        async let bannersTask = CinemaService.shared.fetchBanners()
        async let latestTask = CinemaService.shared.fetchLatest(offset: 0)
        async let groupsTask = CinemaService.shared.fetchVideoGroups()

        do {
            banners = (try? await bannersTask) ?? []
            latest = try await latestTask
            groups = (try? await groupsTask) ?? []
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
