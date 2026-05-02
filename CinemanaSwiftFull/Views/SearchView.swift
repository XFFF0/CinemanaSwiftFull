import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("ابحث عن فيلم أو مسلسل", text: $vm.query)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .onSubmit { Task { await vm.search() } }

                    if !vm.query.isEmpty {
                        Button {
                            vm.query = ""
                            vm.results = []
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if vm.isLoading {
                    ProgressView().padding(.top, 80)
                } else if let error = vm.errorMessage {
                    Text(error).foregroundStyle(.red).padding(.top, 80)
                } else if vm.results.isEmpty {
                    Spacer()
                    Text("اكتب اسم فيلم للبحث")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    List(vm.results) { movie in
                        NavigationLink {
                            MovieDetailsView(movie: movie)
                        } label: {
                            MovieRow(movie: movie)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
            .padding()
            .background(Color(red: 0.03, green: 0.05, blue: 0.10))
            .navigationTitle("البحث")
        }
    }
}

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.white.opacity(0.08)
            }
            .frame(width: 70, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .trailing, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(movie.year ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("⭐️ \(movie.ratingText)")
                    .font(.caption)
            }

            Spacer()
        }
    }
}
