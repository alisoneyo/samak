import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            Color.riddletCream

            // Subtle dot grid
            Canvas { ctx, size in
                let spacing: CGFloat = 20
                let radius:  CGFloat = 1.3
                var x = spacing / 2
                while x < size.width {
                    var y = spacing / 2
                    while y < size.height {
                        let dot = Path(ellipseIn: CGRect(
                            x: x - radius, y: y - radius,
                            width: radius * 2, height: radius * 2
                        ))
                        ctx.fill(dot, with: .color(Color(hex: "B8AFA0").opacity(0.55)))
                        y += spacing
                    }
                    x += spacing
                }
            }
        }
        .ignoresSafeArea()
    }
}
