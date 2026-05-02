import SwiftUI

struct DownloadsView: View {
    @State private var files: [URL] = []

    var body: some View {
        NavigationStack {
            List(files, id: \.self) { file in
                Text(file.lastPathComponent)
            }
            .navigationTitle("التحميلات")
            .onAppear { loadFiles() }
        }
    }

    private func loadFiles() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        files = (try? FileManager.default.contentsOfDirectory(at: docs, includingPropertiesForKeys: nil)) ?? []
    }
}
