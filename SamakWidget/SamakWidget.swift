import WidgetKit
import SwiftUI

// MARK: - Shared Constants

private enum SamakWidgetConfig {
    static let appGroup    = SharedPromiseConfig.appGroup
    static let deepLinkURL = URL(string: "aldra://today")!
}

// MARK: - Models

struct SamakPromise: Codable {
    let id: Int
    let theme: String
    let reference: String
    let front: Front
    let back: Back

    struct Front: Codable {
        let promise: String
        let reference: String
        let theme: String
    }
    struct Back: Codable {
        let reflection: String
        let prayer: String
    }
}

// MARK: - Data Loading

private func loadPromises() -> [SamakPromise] {
    if let groupURL = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: SamakWidgetConfig.appGroup)?
        .appendingPathComponent("promises.json"),
       let data = try? Data(contentsOf: groupURL),
       let promises = try? JSONDecoder().decode([SamakPromise].self, from: data) {
        return promises
    }
    if let url = Bundle.main.url(forResource: "promises", withExtension: "json"),
       let data = try? Data(contentsOf: url),
       let promises = try? JSONDecoder().decode([SamakPromise].self, from: data) {
        return promises
    }
    return []
}

private func todayDayNumber() -> Int {
    let store = PromiseScheduleStore()
    let defaults = UserDefaults(suiteName: SamakWidgetConfig.appGroup)!
    let startDate = (defaults.object(forKey: SharedPromiseConfig.installDateKey) as? Date)
        ?? Calendar.current.startOfDay(for: Date())
    return store.daysSinceStart(from: startDate) + 1
}

private func promiseForToday() -> SamakPromise {
    let promises = loadPromises()
    guard !promises.isEmpty else { return .placeholder }
    let store = PromiseScheduleStore()
    let requiredDayIndex = max(todayDayNumber(), 1)
    guard let snapshot = store.prepareSchedule(
        promiseCount: promises.count,
        requiredDayIndex: requiredDayIndex
    ) else {
        return .placeholder
    }

    let todayIndex = store.daysSinceStart(from: snapshot.startDate)
    guard todayIndex < snapshot.scheduledIndices.count else {
        return .placeholder
    }

    return promises[snapshot.scheduledIndices[todayIndex]]
}

private extension SamakPromise {
    static let placeholder = SamakPromise(
        id: 1,
        theme: "Presence",
        reference: "Isaiah 41:10",
        front: .init(
            promise: "I am with you. Do not be afraid.",
            reference: "Isaiah 41:10",
            theme: "Presence"
        ),
        back: .init(
            reflection: "God's presence is your anchor.",
            prayer: "Lord, remind me you are near."
        )
    )
}

// MARK: - Timeline Entry

struct PromiseEntry: TimelineEntry {
    let date: Date
    let promise: SamakPromise
    let dayNumber: Int
}

// MARK: - Timeline Provider

struct PromiseProvider: TimelineProvider {

    func placeholder(in context: Context) -> PromiseEntry {
        PromiseEntry(date: Date(), promise: .placeholder, dayNumber: 1)
    }

    func getSnapshot(in context: Context, completion: @escaping (PromiseEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PromiseEntry>) -> Void) {
        let midnight = Calendar.current.startOfDay(for: Date().addingTimeInterval(86_400))
        completion(Timeline(entries: [entry()], policy: .after(midnight)))
    }

    private func entry() -> PromiseEntry {
        PromiseEntry(date: Date(), promise: promiseForToday(), dayNumber: todayDayNumber())
    }
}

// MARK: - Design Tokens

private enum Token {
    static let gradientTop    = Color(hex: "#FF6B2B")
    static let gradientBottom = Color(hex: "#C84A2C")
    static let glowColor      = Color(hex: "#FF9A4D")
    static let panelBg        = Color(hex: "#FFF8E8")
    static let panelStroke    = Color(hex: "#E8D9C0")
    static let accent         = Color(hex: "#C84A2C")
    static let textPrimary    = Color(hex: "#1A1008")
    static let textSecondary  = Color(hex: "#8B6A4A")
    static let panelShadow    = Color.black.opacity(0.12)
}

// MARK: - Diagonal Stripes

private struct DiagonalStripes: View {
    var body: some View {
        GeometryReader { geo in
            let size = max(geo.size.width, geo.size.height) * 2
            Canvas { ctx, _ in
                let stride: CGFloat = 10
                var x: CGFloat = -size
                while x < size * 2 {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x + size, y: size))
                    ctx.stroke(path, with: .color(.white.opacity(0.08)), lineWidth: 1)
                    x += stride
                }
            }
        }
    }
}

// MARK: - Lantern with Glow

private struct LanternGlow: View {
    var size: CGFloat

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Token.glowColor.opacity(0.5), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: size * 1.4
            )
            .frame(width: size * 2.8, height: size * 2.8)

            Image("lantern")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}

// MARK: - Small Widget

struct SmallWidgetView: View {
    let entry: PromiseEntry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Token.gradientTop, Token.gradientBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            DiagonalStripes()

            VStack(alignment: .leading, spacing: 6) {
                Text("GOD'S PROMISE TODAY")
                    .font(.custom("DM Sans 18pt Medium", size: 9))
                    .tracking(0.8)
                    .foregroundStyle(Token.accent)

                Text(entry.promise.front.promise.uppercased())
                    .font(.custom("Bungee-Regular", size: 13))
                    .foregroundStyle(Token.textPrimary)
                    .lineLimit(4)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: false)

                Spacer(minLength: 0)

                Text(entry.promise.front.reference)
                    .font(.custom("DMSans_18pt-Regular", size: 10))
                    .foregroundStyle(Token.textSecondary)
                
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Token.panelBg)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Token.accent.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 6)
            .padding(.top, 6)
            .padding(.bottom, 24)
            
            // CTA footer
            VStack {
                Spacer()
                Text("TAP TO REFLECT")
                    .font(.custom("DMSans_18pt-SemiBold", size: 8))
                    .tracking(0.8)
                    .foregroundStyle(Color.white.opacity(0.85))
                    .padding(.bottom, 8)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
// MARK: - Medium Widget
struct MediumWidgetView: View {
    let entry: PromiseEntry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Token.gradientTop, Token.gradientBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            DiagonalStripes()

            // CTA footer
            VStack {
                Spacer()
                Text("TAP TO REFLECT")
                    .font(.custom("DMSans_18pt-Bold", size: 9))
                    .tracking(0.8)
                    .foregroundStyle(Color.white.opacity(0.8))
                    .padding(.bottom, 8)
            }

            // Promise panel
            VStack(alignment: .leading, spacing: 9) {
                Text("GOD'S PROMISE TODAY")
                    .font(.custom("DMSans_18pt-Bold", size: 8))
                    .tracking(0.8)
                    .foregroundStyle(Token.accent)

                Text(entry.promise.front.promise.uppercased())
                    .font(.custom("Bungee-Regular", size: 16))
                    .foregroundStyle(Token.textPrimary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: false)

                Spacer(minLength: 0)

                HStack(alignment: .bottom) {
                    Text(entry.promise.front.reference)
                        .font(.custom("DMSans_18pt-Medium", size: 10))
                        .foregroundStyle(Token.textSecondary)
                    Spacer()
                    Text(entry.promise.front.theme.uppercased())
                        .font(.custom("DMSans_18pt-Medium", size: 9))
                        .foregroundStyle(Token.accent.opacity(0.6))
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Token.panelBg)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Token.accent.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 6)
            .padding(.top, 6)
            .padding(.bottom, 28)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

// MARK: - Entry View

struct SamakWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: PromiseEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Widget Declaration

struct SamakWidget: Widget {
    let kind: String = "AldraWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PromiseProvider()) { entry in
            SamakWidgetEntryView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        colors: [Token.gradientTop, Token.gradientBottom],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    for: .widget
                )
                .widgetURL(SamakWidgetConfig.deepLinkURL)
        }
        .configurationDisplayName("Samak Widget")
        .description("A promise from God, refreshed every morning.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
// MARK: - Hex Color

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Previews

#Preview("Small", as: .systemSmall) {
    SamakWidget()
} timeline: {
    PromiseEntry(date: .now, promise: .placeholder, dayNumber: 1)
}

#Preview("Medium", as: .systemMedium) {
    SamakWidget()
} timeline: {
    PromiseEntry(date: .now, promise: .placeholder, dayNumber: 1)
}
