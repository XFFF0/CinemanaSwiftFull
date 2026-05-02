import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.03, green: 0.05, blue: 0.10).ignoresSafeArea()

                if vm.isLoading {
                    ProgressView()
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(error).foregroundStyle(.red)
                        Button("إعادة المحاولة") {
                            Task { await vm.load() }
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .trailing, spacing: 24) {
                            if let first = vm.banners.first ?? vm.latest.first {
                                NavigationLink {
                                    MovieDetailsView(movie: first)
                                } label: {
                                    HeroMovieView(movie: first)
                                }
                                .buttonStyle(.plain)
                            }

                            MovieSection(title: "الأحدث", movies: vm.latest)

                            ForEach(vm.groups) { group in
                                if let movies = group.videos, !movies.isEmpty {
                                    MovieSection(title: group.title, movies: movies)
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await vm.load()
                    }
                }
            }
            .navigationTitle("سينمانا")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if vm.latest.isEmpty {
                    await vm.load()
                }
            }
        }
    }
}

struct HeroMovieView: View {
    let movie: Movie

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: movie.coverURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                LinearGradient(colors: [.red.opacity(0.8), .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            .frame(height: 240)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                LinearGradient(colors: [.clear, .black.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            )

            VStack(alignment: .trailing, spacing: 8) {
                Text(movie.title)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.trailing)

                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.trailing)

                Label("مشاهدة", systemImage: "play.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.red)
                    .clipShape(Capsule())
            }
            .padding()
        }
    }
}

struct MovieSection: View {
    let title: String
    let movies: [Movie]

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            HStack {
                Spacer()
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetailsView(movie: movie)
                        } label: {
                            MoviePosterCard(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct MoviePosterCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.white.opacity(0.08)
            }
            .frame(width: 135, height: 195)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(movie.title)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .lineLimit(2)
                .frame(width: 135, alignment: .trailing)
        }
    }
}
