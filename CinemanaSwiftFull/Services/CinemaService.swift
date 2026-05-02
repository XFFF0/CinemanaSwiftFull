import Foundation

final class CinemaService {
    static let shared = CinemaService()
    private init() {}

    func fetchBanners() async throws -> [Movie] {
        try await APIClient.shared.get([Movie].self, url: APIConfig.bannerURL())
    }

    func fetchVideoGroups() async throws -> [VideoGroup] {
        try await APIClient.shared.get([VideoGroup].self, url: APIConfig.videoGroupsURL())
    }

    func fetchLatest(offset: Int = 0) async throws -> [Movie] {
        try await APIClient.shared.get([Movie].self, url: APIConfig.latestURL(offset: offset))
    }

    func search(query: String, type: String = "all") async throws -> [Movie] {
        guard let url = APIConfig.searchURL(query: query, type: type) else {
            throw APIError.invalidURL
        }
        return try await APIClient.shared.get([Movie].self, url: url)
    }

    func fetchDetails(movieId: Int) async throws -> Movie {
        try await APIClient.shared.get(Movie.self, url: APIConfig.detailsURL(movieId: movieId))
    }

    func fetchVideos(movieId: Int) async throws -> [VideoFile] {
        try await APIClient.shared.get([VideoFile].self, url: APIConfig.videosURL(movieId: movieId))
    }

    func fetchSubtitles(movieId: Int) async throws -> [SubtitleFile] {
        try await APIClient.shared.get([SubtitleFile].self, url: APIConfig.subtitlesURL(movieId: movieId))
    }

    func fetchRecommendations(movieId: Int, movieName: String) async throws -> [Movie] {
        guard let url = APIConfig.recommendationsURL(movieId: movieId, movieName: movieName) else {
            throw APIError.invalidURL
        }
        return try await APIClient.shared.get([Movie].self, url: url)
    }
}
