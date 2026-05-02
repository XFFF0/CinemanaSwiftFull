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
        details = movie

        do {
            videos = try await CinemaService.shared.fetchVideos(movieId: movieId)
        } catch {
            errorMessage = "فشل جلب روابط المشاهدة: \(error.localizedDescription)"
            videos = []
        }

        subtitles = (try? await CinemaService.shared.fetchSubtitles(movieId: movieId)) ?? []
        recommendations = (try? await CinemaService.shared.fetchRecommendations(movieId: movieId, movieName: movie.title)) ?? []

        isLoading = false
    }
}