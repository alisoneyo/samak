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
    private let epochDate: Date = {
        var c = DateComponents()
        c.year = 2026; c.month = 1; c.day = 1
        return Calendar.current.date(from: c)!
    }()

    // MARK: - Load
    func load() {
        guard
            let url  = Bundle.main.url(forResource: "riddles", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let list = try? JSONDecoder().decode([Riddle].self, from: data)
        else {
            print("⚠️  Could not load riddles.json — make sure it's added to the target.")
            return
        }
        riddles = list
        currentIndex = todayIndex
    }

    // MARK: - Day helpers
    var todayIndex: Int {
        let cal   = Calendar.current
        let start = cal.startOfDay(for: epochDate)
        let today = cal.startOfDay(for: Date())
        let days  = cal.dateComponents([.day], from: start, to: today).day ?? 0
        return max(0, min(days, riddles.count - 1))
    }

    func dayNumber(for index: Int) -> Int { index + 1 }

    func date(for index: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: index, to: epochDate) ?? epochDate
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
        let unlockDay = Calendar.current.startOfDay(for: date(for: index))
        let diff = unlockDay.timeIntervalSince(Date())
        guard diff > 0 else { return "SOON" }
        let h = Int(diff) / 3600
        let m = (Int(diff) % 3600) / 60
        return "\(h)H \(m)M"
    }
}
