import SwiftUI

struct BottomHintView: View {
    @ObservedObject var vm: RiddleViewModel

    private var hint: String {
        guard !vm.riddles.isEmpty else { return "" }
        let i = vm.currentIndex
        if !vm.isUnlocked(i)  { return "← SWIPE BACK TO TODAY" }
        if vm.isFlipped(i)    { return "↩  TAP TO FLIP BACK" }
        return "← SWIPE FOR EARLIER OR LATER →"
    }

    var body: some View {
        Text(hint)
            .font(.dmSans(12))
            .foregroundColor(Color.riddletDark.opacity(0.38))
            .tracking(0.4)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .animation(.easeInOut(duration: 0.2), value: hint)
    }
}
