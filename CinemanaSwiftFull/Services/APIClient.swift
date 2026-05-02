import Foundation

final class APIClient {
    static let shared = APIClient()
    private init() {}

    func get<T: Decodable>(_ type: T.Type, url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 35
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("okhttp/4.9.0", forHTTPHeaderField: "User-Agent")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.badStatus(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            if let text = String(data: data, encoding: .utf8) {
                print("Decode error for URL:", url.absoluteString)
                print(text.prefix(1000))
            }
            throw error
        }
    }
}

enum APIError: LocalizedError {
    case badStatus(Int)
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .badStatus(let code): return "HTTP Error: \(code)"
        case .invalidURL: return "Invalid URL"
        }
    }
}
