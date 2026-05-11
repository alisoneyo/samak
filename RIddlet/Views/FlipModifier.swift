import SwiftUI

/// Animates a 3-D card flip. Drive `angle` from 0 → 180 (front) or -180 → 0 (back).
struct FlipModifier: AnimatableModifier {
    var angle: Double
    var isBack: Bool = false

    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.4
            )
            // Hide when the card is edge-on (past 90°)
            .opacity(isBack ? (angle < -90 ? 0 : 1)
                            : (angle >  90 ? 0 : 1))
    }
}
