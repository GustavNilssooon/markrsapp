import SwiftUI
import FirebaseCore

@main
struct MarkrsApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
} 