import Foundation

struct HomeSection: Identifiable {
    let id = UUID()
    let title: String
    let movies: [Movie]
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var banners: [Movie] = []
    @Published var latest: [Movie] = []
    @Published var sections: [HomeSection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil

        banners = (try? await CinemaService.shared.fetchBanners()) ?? []
        latest = await CinemaService.shared.fetchAllLatest(maxPages: 5)

        let groups = (try? await CinemaService.shared.fetchVideoGroups()) ?? []
        var loadedSections: [HomeSection] = []

        for group in groups {
            let groupId = group.groupID ?? group.list_id ?? ""
            guard !groupId.isEmpty else { continue }

            let movies = await CinemaService.shared.fetchAllGroupVideos(
                groupId: groupId,
                maxPages: 5
            )

            if !movies.isEmpty {
                loadedSections.append(
                    HomeSection(title: group.title, movies: movies)
                )
            }
        }

        sections = loadedSections
        isLoading = false
    }
}