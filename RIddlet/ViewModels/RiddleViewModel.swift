import Foundation
import Combine

class RiddleViewModel: ObservableObject {

    // MARK: - Published state
    @Published var riddles: [Riddle] = []
    @Published var currentIndex: Int = 0
    @Published var flippedCards: Set<Int> = []

    // MARK: - Epoch
    // This is the calendar date of Riddle #1 (Day 1).
    // Adjust it to whenever you want the sequence to start.
    private var epochDate: Date {
        let defaults = UserDefaults(suiteName: "group.com.alison.Riddlet")!
        return defaults.object(forKey: "epochDate") as? Date ?? Date()
    }

    // MARK: - Load
    func load() {
        guard
            let url  = Bundle.main.url(forResource: "promises", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let list = try? JSONDecoder().decode([Riddle].self, from: data)
        else {
            print("⚠️  Could not load riddles.json")
            return
        }
        let visibleCount = min(todayIndex + 2, list.count)
        riddles = Array(list.prefix(visibleCount))
        currentIndex = todayIndex
    }

    // MARK: - Day helpers
    var todayIndex: Int {
        let defaults = UserDefaults.standard
        let offset = defaults.integer(forKey: "promiseOffset")
        let cal = Calendar.current
        let start = cal.startOfDay(for: epochDate)
        let today = cal.startOfDay(for: Date())
        let days = cal.dateComponents([.day], from: start, to: today).day ?? 0
        return (max(0, days) + offset) % 365
    }

    func dayNumber(for index: Int) -> Int { index + 1 }

    func date(for index: Int) -> Date {
        let daysFromToday = index - todayIndex
        return Calendar.current.date(byAdding: .day, value: daysFromToday, to: Date()) ?? Date()
    }

    func isUnlocked(_ index: Int) -> Bool { index <= todayIndex }
    func isToday(_ index: Int) -> Bool    { index == todayIndex }

    // MARK: - Flip helpers
    func isFlipped(_ index: Int) -> Bool { flippedCards.contains(index) }

    func toggleFlip(_ index: Int) {
        if flippedCards.contains(index) {
            flippedCards.remove(index)
        } else {
            flippedCards.insert(index)
        }
    }

    // MARK: - Countdown
    func timeUntilUnlock(for index: Int) -> String {
        let daysFromToday = index - todayIndex
        let unlockDay = Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day, value: daysFromToday, to: Date()) ?? Date()
        )
        let diff = unlockDay.timeIntervalSince(Date())
        guard diff > 0 else { return "SOON" }
        let d = Int(diff) / 86400
        let h = (Int(diff) % 86400) / 3600
        let m = (Int(diff) % 3600) / 60
        let s = Int(diff) % 60
        if d > 0 {
            return "\(d)D : \(h)H : \(m)M : \(s)S"
        }
        return "\(h)H : \(m)M : \(s)S"
    }
}
