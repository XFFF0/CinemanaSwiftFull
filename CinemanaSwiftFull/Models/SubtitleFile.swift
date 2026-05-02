import Foundation

struct SubtitleFile: Identifiable, Codable, Hashable {
    var id: String { fileUrl ?? file ?? name ?? UUID().uuidString }

    let name: String?
    let lang: String?
    let language: String?
    let file: String?
    let fileUrl: String?
    let url: String?

    var title: String {
        language ?? lang ?? name ?? "Subtitle"
    }

    var subtitleURL: URL? {
        let raw = fileUrl ?? url ?? file ?? ""
        if raw.hasPrefix("http") { return URL(string: raw) }
        if raw.isEmpty { return nil }
        return URL(string: "https://cnth2.shabakaty.cc/vascin-translation-files/\(raw)")
    }
}
