import Foundation

extension String {
    var cleanedText: String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.contains("Ø") || trimmed.contains("Ù") {
            if let data = trimmed.data(using: .isoLatin1),
               let fixed = String(data: data, encoding: .utf8) {
                return fixed
            }
        }
        return trimmed
    }
}
