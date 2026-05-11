import Foundation
import WidgetKit

enum SharedPromiseConfig {
    static let appGroup = "group.com.alison.Riddlet"
    static let installDateKey = "installDate"
    static let promiseScheduleKey = "promiseSchedule"
}

struct PromiseScheduleSnapshot {
    let startDate: Date
    let scheduledIndices: [Int]
}

final class PromiseScheduleStore {
    private let defaults = UserDefaults(suiteName: SharedPromiseConfig.appGroup)!
    private let calendar = Calendar.current

    func persistedStartDate() -> Date? {
        defaults.object(forKey: SharedPromiseConfig.installDateKey) as? Date
    }

    func prepareSchedule(promiseCount: Int, requiredDayIndex: Int) -> PromiseScheduleSnapshot? {
        guard promiseCount > 0 else { return nil }

        let safeRequiredDayIndex = max(requiredDayIndex, 0)
        var didChange = false

        let startDate: Date
        if let stored = defaults.object(forKey: SharedPromiseConfig.installDateKey) as? Date {
            startDate = stored
        } else {
            startDate = calendar.startOfDay(for: Date())
            defaults.set(startDate, forKey: SharedPromiseConfig.installDateKey)
            didChange = true
        }

        var schedule = defaults.array(forKey: SharedPromiseConfig.promiseScheduleKey) as? [Int] ?? []
        if schedule.contains(where: { $0 < 0 || $0 >= promiseCount }) {
            schedule = []
            didChange = true
        }

        let requiredCount = safeRequiredDayIndex + 1
        while schedule.count < requiredCount {
            schedule.append(contentsOf: Array(0..<promiseCount).shuffled())
            didChange = true
        }

        if didChange {
            defaults.set(schedule, forKey: SharedPromiseConfig.promiseScheduleKey)
            WidgetCenter.shared.reloadAllTimelines()
        }

        return PromiseScheduleSnapshot(startDate: startDate, scheduledIndices: schedule)
    }

    func daysSinceStart(from startDate: Date) -> Int {
        let start = calendar.startOfDay(for: startDate)
        let today = calendar.startOfDay(for: Date())
        let days = calendar.dateComponents([.day], from: start, to: today).day ?? 0
        return max(days, 0)
    }

    func date(forDayIndex dayIndex: Int, startDate: Date) -> Date {
        calendar.date(byAdding: .day, value: dayIndex, to: calendar.startOfDay(for: startDate)) ?? startDate
    }
}
