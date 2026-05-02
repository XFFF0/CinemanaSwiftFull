import Foundation

struct VideoFile: Identifiable, Codable, Hashable {
    var id: String { videoUrl }

    let name: String
    let resolution: String?
    let container: String?
    let transcoddedFileName: String?
    let videoUrl: String

    var label: String {
        if let resolution, !resolution.isEmpty {
            return resolution == "2160p" ? "4K" : resolution
        }
        if name.lowercased().contains("4k") { return "4K" }
        return name
    }

    var url: URL? {
        URL(string: videoUrl)
    }
}
