import Foundation

@MainActor
final class DownloadManager: NSObject, ObservableObject {
    @Published var progress: Double = 0
    @Published var isDownloading = false
    @Published var lastDownloadedFile: URL?
    @Published var errorMessage: String?

    private var observation: NSKeyValueObservation?

    func download(_ video: VideoFile) {
        guard let url = video.url else { return }

        isDownloading = true
        progress = 0
        errorMessage = nil

        var request = URLRequest(url: url)
        request.setValue("okhttp/4.9.0", forHTTPHeaderField: "User-Agent")

        let task = URLSession.shared.downloadTask(with: request) { [weak self] localURL, _, error in
            Task { @MainActor in
                guard let self else { return }
                self.isDownloading = false

                if let error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let localURL else { return }

                let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let base = video.transcoddedFileName ?? UUID().uuidString
                let filename = base.hasSuffix(".mp4") ? base : base + ".mp4"
                let destination = docs.appendingPathComponent(filename)

                try? FileManager.default.removeItem(at: destination)

                do {
                    try FileManager.default.moveItem(at: localURL, to: destination)
                    self.lastDownloadedFile = destination
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }

        observation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            Task { @MainActor in
                self?.progress = progress.fractionCompleted
            }
        }

        task.resume()
    }
}
