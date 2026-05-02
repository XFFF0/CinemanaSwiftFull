import Foundation

enum APIConfig {
    static let baseURL = URL(string: "https://cinemana.shabakaty.cc/api/android")!
    static let recommendBaseURL = URL(string: "https://recommend.shabakaty.cc/api/recommendation")!

    static func endpoint(_ path: String) -> URL {
        baseURL.appendingPathComponent(path)
    }

    static func bannerURL(level: Int = 0) -> URL {
        endpoint("banner/level/\(level)")
    }

    static func videoGroupsURL(lang: String = "ar", level: Int = 0) -> URL {
        endpoint("videoGroups/lang/\(lang)/level/\(level)")
    }

    static func latestURL(level: Int = 0, offset: Int = 0) -> URL {
        endpoint("newlyVideosItems/level/\(level)/offset/\(offset)")
    }

    static func searchURL(query: String, type: String = "all") -> URL? {
        var components = URLComponents(url: endpoint("AdvancedSearch"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "type", value: type),
            URLQueryItem(name: "videoTitle", value: query),
            URLQueryItem(name: "year", value: "1900,2026")
        ]
        return components?.url
    }

    static func detailsURL(movieId: Int) -> URL {
        endpoint("allVideoInfo/id/\(movieId)")
    }

    static func videosURL(movieId: Int) -> URL {
        endpoint("transcoddedFiles/id/\(movieId)")
    }

    static func subtitlesURL(movieId: Int) -> URL {
        endpoint("translationFiles/id/\(movieId)")
    }

    static func recommendationsURL(movieId: Int, movieName: String) -> URL? {
        var components = URLComponents(url: recommendBaseURL.appendingPathComponent("recommend"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "MovieId", value: String(movieId)),
            URLQueryItem(name: "MovieName", value: movieName),
            URLQueryItem(name: "ReProcessIfExpired", value: "true")
        ]
        return components?.url
    }
}
