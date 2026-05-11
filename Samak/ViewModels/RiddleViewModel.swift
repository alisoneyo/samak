import Foundation
import Combine

class RiddleViewModel: ObservableObject {
    @Published var riddles: [Riddle] = []
    @Published var currentIndex: Int = 0
    @Published var flippedCards: Set<Int> = []

    private let scheduleStore = PromiseScheduleStore()
    private var startDate = Date()
    private var lastLoadedTodayIndex = 0

    func load() {
        let hadVisibleRiddles = !riddles.isEmpty

        guard
            let url  = Bundle.main.url(forResource: "promises", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let list = try? JSONDecoder().decode([Riddle].self, from: data)
        else {
            print("⚠️  Could not load promises.json")
            return
        }

        let anchorDate = scheduleStore.persistedStartDate() ?? startDate
        guard let snapshot = scheduleStore.prepareSchedule(
            promiseCount: list.count,
            requiredDayIndex: scheduleStore.daysSinceStart(from: anchorDate) + 1
        ) else {
            riddles = []
            currentIndex = 0
            return
        }

        startDate = snapshot.startDate
        let today = scheduleStore.daysSinceStart(from: startDate)
        lastLoadedTodayIndex = today

        let visibleCount = min(today + 2, snapshot.scheduledIndices.count)
        riddles = Array(snapshot.scheduledIndices.prefix(visibleCount)).map { list[$0] }
        currentIndex = min(max(currentIndex, 0), max(riddles.count - 1, 0))
        if !hadVisibleRiddles || currentIndex > today {
            currentIndex = today
        }
    }

    var todayIndex: Int {
        scheduleStore.daysSinceStart(from: startDate)
    }

    @discardableResult
    func refreshIfNeeded() -> Bool {
        let updatedTodayIndex = scheduleStore.daysSinceStart(from: startDate)
        guard updatedTodayIndex != lastLoadedTodayIndex else { return false }
        load()
        return true
    }

    func dayNumber(for index: Int) -> Int { index + 1 }

    func date(for index: Int) -> Date {
        scheduleStore.date(forDayIndex: index, startDate: startDate)
    }

    func isUnlocked(_ index: Int) -> Bool { index <= todayIndex }
    func isToday(_ index: Int) -> Bool    { index == todayIndex }

    func isFlipped(_ index: Int) -> Bool { flippedCards.contains(index) }

    func toggleFlip(_ index: Int) {
        if flippedCards.contains(index) {
            flippedCards.remove(index)
        } else {
            flippedCards.insert(index)
        }
    }

    func timeUntilUnlock(for index: Int) -> String {
        let unlockDay = Calendar.current.startOfDay(for: date(for: index))
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
