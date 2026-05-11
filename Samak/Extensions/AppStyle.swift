import SwiftUI

// MARK: - Colors
extension Color {
    static let riddletOrange      = Color(hex: "E8531A")
    static let riddletOrangeLight = Color(hex: "F27A40")
    static let riddletDark        = Color(hex: "1C1917")
    static let riddletCream = Color(hex: "F1E9DA")
    static let riddletCard        = Color(hex: "FDFAF4")

    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8)  & 0xFF) / 255
        let b = Double( rgb        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Fonts
extension Font {
    static func bungee(_ size: CGFloat) -> Font {
        .custom("Bungee-Regular", size: size)
    }
    static func dmSans(_ size: CGFloat) -> Font {
        .custom("DMSans_18pt-Regular", size: size)
    }
    static func dmSansMedium(_ size: CGFloat) -> Font {
        .custom("DMSans_18pt-Medium", size: size)
    }
    static func dmSansBold(_ size: CGFloat) -> Font {
        .custom("DMSans_18pt-Bold", size: size)
    }
}
