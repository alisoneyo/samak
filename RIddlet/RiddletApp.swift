import SwiftUI

@main
struct RiddletApp: App {
    
    init() {
        setupEpochIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func setupEpochIfNeeded() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "epochDate") == nil {
            defaults.set(Date(), forKey: "epochDate")
            let randomOffset = Int.random(in: 0..<365)
            defaults.set(randomOffset, forKey: "promiseOffset")
        }
    }
}
