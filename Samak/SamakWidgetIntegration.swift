// SamakWidgetIntegration.swift
// Keeps the bundled promise data available to the widget target.

import Foundation
import WidgetKit

enum SamakWidgetDataSync {

    private static let appGroup = "group.com.alison.Riddlet" // ← match your actual App Group

    static func syncPromisesToAppGroup() {
        guard
            let sourceURL = Bundle.main.url(forResource: "promises", withExtension: "json"),
            let groupURL  = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
                .appendingPathComponent("promises.json")
        else { return }

        // Only copy if source is newer than destination
        let fm = FileManager.default
        if let srcDate = (try? fm.attributesOfItem(atPath: sourceURL.path))?[.modificationDate] as? Date,
           let dstDate = (try? fm.attributesOfItem(atPath: groupURL.path))?[.modificationDate] as? Date,
           srcDate <= dstDate {
            return // Already up to date
        }

        try? fm.removeItem(at: groupURL)
        try? fm.copyItem(at: sourceURL, to: groupURL)

        // Tell WidgetKit the timeline may have changed
        WidgetCenter.shared.reloadAllTimelines()
    }
}
