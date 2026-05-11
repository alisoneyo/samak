import SwiftUI

@main
struct SamakApp: App {
    
    init() {
        SamakWidgetDataSync.syncPromisesToAppGroup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
