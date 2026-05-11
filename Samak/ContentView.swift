import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var vm: RiddleViewModel
    @State private var dragOffset: CGFloat = 0
    @State private var selectedIndex: Int
    private let refreshTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let cardWidth: CGFloat = 320
    private let cardSpacing: CGFloat = 16

    init() {
        let viewModel = RiddleViewModel()
        viewModel.load()
        _vm = StateObject(wrappedValue: viewModel)
        _selectedIndex = State(initialValue: viewModel.currentIndex)
    }

    var body: some View {
        ZStack {
            AppBackground()

            if vm.riddles.isEmpty {
                ProgressView()
                    .scaleEffect(1.4)
                    .tint(Color.riddletOrange)
            } else {
                VStack(spacing: 0) {

                    AppHeaderView(vm: vm)

                    GeometryReader { geo in
                        let totalCardWidth = cardWidth + cardSpacing
                        let centerOffset = (geo.size.width - cardWidth) / 2

                        HStack(spacing: cardSpacing) {
                            ForEach(vm.riddles.indices, id: \.self) { i in
                                RiddleCardView(vm: vm, index: i)
                                    .frame(width: cardWidth)
                                    .scaleEffect(selectedIndex == i ? 1.0 : 0.92)
                                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedIndex)
                            }
                        }
                        .offset(x: centerOffset - CGFloat(selectedIndex) * totalCardWidth + dragOffset)
                        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedIndex)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    let velocity = value.predictedEndTranslation.width
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                        if velocity < -threshold && selectedIndex < vm.riddles.count - 1 {
                                            selectedIndex += 1
                                        } else if velocity > threshold && selectedIndex > 0 {
                                            selectedIndex -= 1
                                        }
                                        dragOffset = 0
                                    }
                                    vm.currentIndex = selectedIndex
                                }
                        )
                    }
                    .frame(maxHeight: 500)
                    .padding(.bottom, 12)

                    Spacer()
                }
            }
        }
        .onOpenURL { url in
            if url.absoluteString == "aldra://today" {
                selectedIndex = vm.todayIndex
                vm.currentIndex = vm.todayIndex
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            vm.load()
            selectedIndex = vm.todayIndex
        }
        .onReceive(refreshTimer) { _ in
            if vm.refreshIfNeeded() {
                selectedIndex = min(selectedIndex, max(vm.riddles.count - 1, 0))
                vm.currentIndex = selectedIndex
            }
        }
    }
}

#Preview {
    ContentView()
}
