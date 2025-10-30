import SwiftUI

@main
struct SoulTalkApp: App {
    @StateObject private var store = AppDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
