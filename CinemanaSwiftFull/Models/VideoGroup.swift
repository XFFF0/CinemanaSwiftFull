import Foundation

struct VideoGroup: Identifiable, Codable, Hashable {
    var id: String { groupID ?? list_id ?? custom_en_title ?? UUID().uuidString }

    let groupID: String?
    let list_id: String?
    let ar_title: String?
    let en_title: String?
    let custom_ar_title: String?
    let custom_en_title: String?
    let item_order_list: String?
    let videos: [Movie]?

    var title: String {
        let customAr = custom_ar_title?.cleanedText ?? ""
        if !customAr.isEmpty { return customAr }

        let ar = ar_title?.cleanedText ?? ""
        if !ar.isEmpty { return ar }

        let customEn = custom_en_title?.cleanedText ?? ""
        if !customEn.isEmpty { return customEn }

        return en_title?.cleanedText ?? "قسم"
    }
}
