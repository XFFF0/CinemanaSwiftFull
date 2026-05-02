import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 110))
                    .foregroundStyle(.red)

                Text("ضيف")
                    .font(.title.bold())

                VStack(spacing: 0) {
                    InfoRow(title: "الإصدار", value: "1.0.0")
                    Divider().background(.white.opacity(0.1))
                    InfoRow(title: "السيرفر", value: APIConfig.baseURL.host ?? "-")
                }
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Spacer()
            }
            .padding()
            .background(Color(red: 0.03, green: 0.05, blue: 0.10))
            .navigationTitle("حسابي")
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(value).foregroundStyle(.secondary)
            Spacer()
            Text(title)
        }
        .padding()
    }
}
