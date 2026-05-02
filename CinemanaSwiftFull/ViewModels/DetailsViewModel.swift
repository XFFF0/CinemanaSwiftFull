import Foundation

@MainActor
final class DetailsViewModel: ObservableObject {
    @Published var details: Movie?
    @Published var videos: [VideoFile] = []
    @Published var subtitles: [SubtitleFile] = []
    @Published var recommendations: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load(movie: Movie) async {
        let movieId = movie.id
        isLoading = true
        errorMessage = nil

        async let detailsTask = CinemaService.shared.fetchDetails(movieId: movieId)
        async let videosTask = CinemaService.shared.fetchVideos(movieId: movieId)
        async let subtitlesTask = CinemaService.shared.fetchSubtitles(movieId: movieId)
        async let recTask = CinemaService.shared.fetchRecommendations(movieId: movieId, movieName: movie.title)

        do {
            details = (try? await detailsTask) ?? movie
            videos = (try? await videosTask) ?? []
            subtitles = (try? await subtitlesTask) ?? []
            recommendations = (try? await recTask) ?? []
        }

        isLoading = false
    }
}
