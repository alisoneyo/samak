import SwiftUI

struct ContentView: View {
    @StateObject private var vm = RiddleViewModel()

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

                    // Horizontal page-swipe between days
                    TabView(selection: $vm.currentIndex) {
                        ForEach(vm.riddles.indices, id: \.self) { i in
                            RiddleCardView(vm: vm, index: i)
                                .padding(.horizontal, 24)
                                .tag(i)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    BottomHintView(vm: vm)
                }
            }
        }
        .onAppear { vm.load() }
    }
}

#Preview {
    ContentView()
}
