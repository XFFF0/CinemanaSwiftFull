import SwiftUI

@main
struct CinemanaSwiftFullApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
    }
}
