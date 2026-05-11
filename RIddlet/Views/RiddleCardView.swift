import SwiftUI

struct RiddleCardView: View {
    @ObservedObject var vm: RiddleViewModel
    let index: Int

    private var isFlipped:  Bool { vm.isFlipped(index) }
    private var isUnlocked: Bool { vm.isUnlocked(index) }

    var body: some View {
        Group {
            if !isUnlocked {
                LockedCardView(
                    timeUntilUnlock: vm.timeUntilUnlock(for: index),
                    vm: vm,
                    index: index
                )
            } else {
                ZStack {
                    // Front face: starts visible (angle 0), rotates to 180 when flipped
                    CardFrontView(riddle: vm.riddles[index], vm: vm, index: index)
                        .modifier(FlipModifier(angle: isFlipped ? 180 : 0, isBack: false))

                    // Back face: starts behind (angle -180), rotates to 0 when flipped
                    CardBackView(riddle: vm.riddles[index], vm: vm, index: index)
                        .modifier(FlipModifier(angle: isFlipped ? 0 : -180, isBack: true))
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                        vm.toggleFlip(index)
                    }
                }
            }
        }
    }
}
