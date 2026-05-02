import Foundation

struct Movie: Identifiable, Codable, Hashable {
    var id: Int { Int(nb ?? "") ?? movieId ?? 0 }

    let nb: String?
    let movieId: Int?
    let movieName: String?

    let ar_title: String?
    let en_title: String?
    let other_title: String?
    let stars: String?
    let ar_content: String?
    let en_content: String?
    let mDate: String?
    let year: String?
    let kind: String?
    let season: String?
    let duration: String?

    let img: String?
    let imgThumb: String?
    let imgObjUrl: String?
    let imgThumbObjUrl: String?
    let imgMediumThumbObjUrl: String?

    let link: String?
    let trailer: String?
    let arTranslationFile: String?
    let enTranslationFile: String?
    let imdbUrlRef: String?
    let categories: [MovieCategory]?
    let actorsInfo: [StaffMember]?
    let directorsInfo: [StaffMember]?
    let recommendations: [Movie]?

    var title: String {
        let ar = ar_title?.cleanedText ?? ""
        if !ar.isEmpty { return ar }
        let en = en_title?.cleanedText ?? ""
        if !en.isEmpty { return en }
        return movieName?.cleanedText ?? "بدون عنوان"
    }

    var overview: String {
        let ar = ar_content?.cleanedText ?? ""
        if !ar.isEmpty { return ar }
        return en_content?.cleanedText ?? ""
    }

    var ratingText: String {
        stars?.cleanedText ?? "0"
    }

    var posterURL: URL? {
        if let imgMediumThumbObjUrl, let url = smartURL(imgMediumThumbObjUrl) { return url }
        if let imgObjUrl, let url = smartURL(imgObjUrl) { return url }
        if let imgThumbObjUrl, let url = smartURL(imgThumbObjUrl) { return url }
        if let img, let url = smartURL("https://cnth2.shabakaty.cc/vascin-poster-images/\(img)") { return url }
        return nil
    }

    var coverURL: URL? {
        if let imgObjUrl, imgObjUrl.contains("cover"), let url = smartURL(imgObjUrl) { return url }
        return posterURL
    }

    private func smartURL(_ raw: String) -> URL? {
        if raw.hasPrefix("http") { return URL(string: raw) }
        if raw.hasPrefix("vascin-") {
            return URL(string: "https://cnth2.shabakaty.cc/\(raw)")
        }
        return URL(string: raw)
    }
}

struct MovieCategory: Codable, Hashable {
    let en_title: String?
    let ar_title: String?

    var title: String {
        let ar = ar_title?.cleanedText ?? ""
        return ar.isEmpty ? (en_title?.cleanedText ?? "") : ar
    }
}

struct StaffMember: Codable, Hashable, Identifiable {
    var id: String { nb ?? name ?? UUID().uuidString }

    let nb: String?
    let name: String?
    let role: String?
    let staff_img: String?
    let staff_img_thumb: String?
    let staff_img_medium_thumb: String?
}
