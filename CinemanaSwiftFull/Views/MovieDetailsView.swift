import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie

    @StateObject private var vm = DetailsViewModel()
    @StateObject private var playerVM = PlayerViewModel()
    @StateObject private var downloader = DownloadManager()
    @State private var showPlayer = false

    private var shownMovie: Movie {
        vm.details ?? movie
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 20) {
                AsyncImage(url: shownMovie.coverURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.white.opacity(0.08)
                }
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 24))

                Text(shownMovie.title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.trailing)

                HStack {
                    Text(shownMovie.year ?? "")
                    Text("⭐️ \(shownMovie.ratingText)")
                }
                .foregroundStyle(.secondary)

                if let categories = shownMovie.categories, !categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categories, id: \.title) { cat in
                                Text(cat.title)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                Text(shownMovie.overview)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)

                if vm.isLoading {
                    ProgressView()
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.trailing)
                }

                VStack(spacing: 12) {
                    Button {
                        if let best = vm.videos.last {
                            playerVM.play(video: best)
                            showPlayer = true
                        }
                    } label: {
                        Label("مشاهدة", systemImage: "play.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .disabled(vm.videos.isEmpty)

                    QualitySelector(videos: vm.videos) { video in
                        playerVM.play(video: video)
                        showPlayer = true
                    }

                    if !vm.subtitles.isEmpty {
                        Menu("الترجمة") {
                            ForEach(vm.subtitles) { sub in
                                Button(sub.title) {}
                            }
                        }
                    }

                    if let best = vm.videos.last {
                        Button {
                            downloader.download(best)
                        } label: {
                            Label("تحميل أعلى جودة", systemImage: "arrow.down.circle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.bordered)
                    }

                    if downloader.isDownloading {
                        ProgressView(value: downloader.progress)

                        Text("\(Int(downloader.progress * 100))%")
                            .foregroundStyle(.secondary)
                    }

                    if let file = downloader.lastDownloadedFile {
                        Text("تم التحميل: \(file.lastPathComponent)")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }

                if !vm.recommendations.isEmpty {
                    MovieSection(title: "مقترحات", movies: vm.recommendations)
                }
            }
            .padding()
        }
        .background(Color(red: 0.03, green: 0.05, blue: 0.10))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.load(movie: movie)
        }
        .fullScreenCover(isPresented: $showPlayer) {
            CustomPlayerView(playerVM: playerVM)
        }
    }
}

struct QualitySelector: View {
    let videos: [VideoFile]
    let onSelect: (VideoFile) -> Void

    var body: some View {
        if videos.isEmpty {
            Text("لا توجد روابط مشاهدة")
                .foregroundStyle(.secondary)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(videos) { video in
                        Button(video.label) {
                            onSelect(video)
                        }
                        .buttonStyle(.bordered)
                        .tint(video.label == "4K" ? .red : .gray)
                    }
                }
            }
        }
    }
}