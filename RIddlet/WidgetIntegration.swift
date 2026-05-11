// WidgetIntegration.swift
// Add this file to your MAIN APP target only.
// It handles two things:
//   1. Copying promises.json into the shared App Group on launch (so the widget can read it)
//   2. Handling the deep link "aldra://today" to open today's card

import Foundation
import WidgetKit
import SwiftUI
import Combine

// MARK: - App Group Data Sync

/// Call this once at app launch (e.g. in your @main App.init or onAppear of ContentView).
/// It copies promises.json into the shared container so the widget target can always read it,
/// even if the user hasn't opened the app yet on a fresh install.
///
/// Usage in your @main App struct:
///
///     .onAppear {
///         AldraWidgetDataSync.syncPromisesToAppGroup()
///     }
///
enum AldraWidgetDataSync {

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

// MARK: - Deep Link Handler

/// A simple router you attach to your root view with `.onOpenURL`.
/// The widget fires "aldra://today" when tapped.
///
/// Usage:
///
///     ContentView()
///         .onOpenURL { url in
///             AldraDeepLink.handle(url, navigator: navigator)
///         }
///
/// Where `navigator` is your @StateObject or @EnvironmentObject that controls
/// which card / day is currently displayed.

struct AldraDeepLink {

    /// Routes an incoming URL to the correct destination.
    /// Returns the resolved destination so you can act on it in your view layer.
    @discardableResult
    static func handle(_ url: URL, navigator: AldraNavigator) -> Destination? {
        guard url.scheme == "aldra" else { return nil }
        switch url.host {
        case "today":
            navigator.openToday()
            return .today
        case "day":
            if let dayStr = url.pathComponents.dropFirst().first,
               let day    = Int(dayStr) {
                navigator.openDay(day)
                return .day(day)
            }
        default:
            break
        }
        return nil
    }

    enum Destination {
        case today
        case day(Int)
    }
}

// MARK: - Navigator

/// Lightweight observable router. Adapt this to however your existing
/// navigation state is managed (e.g. a TabView selection, a sheet flag, etc.)
///
/// If you already have an equivalent in RiddleViewModel or ContentView,
/// just add the `openToday()` method there and skip this class.
@MainActor
final class AldraNavigator: ObservableObject {

    @Published var selectedDayIndex: Int = 0  // index in your carousel
    @Published var isShowingCard: Bool = false

    private let epochDate: Date = {
        var c = DateComponents()
        c.year = 2025; c.month = 1; c.day = 1
        return Calendar.current.date(from: c)!
    }()

    func openToday() {
        let today = Calendar.current.startOfDay(for: Date())
        let epoch = Calendar.current.startOfDay(for: epochDate)
        let day   = (Calendar.current.dateComponents([.day], from: epoch, to: today).day ?? 0) + 1
        openDay(day)
    }

    func openDay(_ dayNumber: Int) {
        // dayNumber is 1-indexed; your carousel likely uses 0-indexed positions
        selectedDayIndex = max(0, dayNumber - 1)
        isShowingCard = true
    }
}

// MARK: - WidgetKit Reload Triggers

/// Call these from your main app whenever promise data changes.
extension WidgetCenter {

    /// Convenience — reloads Aldra's widget timeline.
    func reloadAldraWidget() {
        reloadTimelines(ofKind: "AldraWidget")
    }
}
