import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("الرئيسية", systemImage: "house.fill") }

            SearchView()
                .tabItem { Label("البحث", systemImage: "magnifyingglass") }

            DownloadsView()
                .tabItem { Label("التحميلات", systemImage: "arrow.down.circle.fill") }

            AccountView()
                .tabItem { Label("حسابي", systemImage: "person.fill") }
        }
        .accentColor(.red)
    }
}
