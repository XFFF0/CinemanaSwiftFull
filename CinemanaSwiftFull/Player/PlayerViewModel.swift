import AVFoundation
import Foundation

@MainActor
final class PlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var currentQuality: String = ""
    @Published var subtitleFontSize: CGFloat = 22
    @Published var playbackSpeed: Float = 1.0

    func play(video: VideoFile) {
        guard let url = video.url else { return }

        let headers = [
            "User-Agent": "okhttp/4.9.0",
            "Accept": "*/*",
            "Connection": "Keep-Alive"
        ]

        let asset = AVURLAsset(url: url, options: [
            "AVURLAssetHTTPHeaderFieldsKey": headers
        ])

        let item = AVPlayerItem(asset: asset)
        let newPlayer = AVPlayer(playerItem: item)
        player = newPlayer
        currentQuality = video.label
        newPlayer.play()
    }

    func setSpeed(_ speed: Float) {
        playbackSpeed = speed
        player?.rate = speed
    }

    func pause() {
        player?.pause()
    }
}
