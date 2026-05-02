import SwiftUI
import AVKit

struct CustomPlayerView: View {
    @ObservedObject var playerVM: PlayerViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let player = playerVM.player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            } else {
                Text("لا يوجد فيديو")
                    .foregroundStyle(.white)
            }

            VStack {
                HStack {
                    Button {
                        playerVM.pause()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Text(playerVM.currentQuality)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                .padding()

                Spacer()

                HStack(spacing: 12) {
                    Button("0.75x") { playerVM.setSpeed(0.75) }
                    Button("1x") { playerVM.setSpeed(1.0) }
                    Button("1.25x") { playerVM.setSpeed(1.25) }
                    Button("1.5x") { playerVM.setSpeed(1.5) }
                }
                .buttonStyle(.bordered)
                .tint(.white)
                .padding()
            }
        }
    }
}
