import SwiftUI
import Combine

struct WaxSealIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "E8552B"))
                .frame(width: 80, height: 80)

            Circle()
                .strokeBorder(Color(hex: "C84A2C"), lineWidth: 3)
                .frame(width: 66, height: 66)

            Rectangle()
                .fill(Color(hex: "C84A2C").opacity(0.5))
                .frame(width: 2, height: 36)

            Rectangle()
                .fill(Color(hex: "C84A2C").opacity(0.5))
                .frame(width: 36, height: 2)

            Rectangle()
                .fill(Color(hex: "C84A2C").opacity(0.5))
                .frame(width: 2, height: 36)
                .rotationEffect(.degrees(45))

            Rectangle()
                .fill(Color(hex: "C84A2C").opacity(0.5))
                .frame(width: 36, height: 2)
                .rotationEffect(.degrees(45))

            Circle()
                .fill(Color(hex: "C84A2C"))
                .frame(width: 10, height: 10)
        }
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct LockedCardView: View {
    @ObservedObject var vm: RiddleViewModel
    let index: Int

    @State private var timeRemaining: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private func calculateTimeRemaining() -> String {
        let unlockDate = Calendar.current.startOfDay(for: vm.date(for: index))
        let now = Date()
        let diff = unlockDate.timeIntervalSince(now)

        guard diff > 0 else { return "SOON" }

        let days    = Int(diff) / 86400
        let hours   = (Int(diff) % 86400) / 3600
        let minutes = (Int(diff) % 3600) / 60
        let seconds = Int(diff) % 60

        if days > 0 {
            return String(format: "%dd : %02dh : %02dm : %02ds", days, hours, minutes, seconds)
        } else {
            return String(format: "%02dh : %02dm : %02ds", hours, minutes, seconds)
        }
    }

    var body: some View {
        ZStack {
            // Dark brown background
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "2C2218"), Color(hex: "171210")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Subtle diagonal texture
            Canvas { ctx, size in
                let spacing: CGFloat = 13
                var x: CGFloat = -size.height
                while x < size.width + size.height {
                    var line = Path()
                    line.move(to: CGPoint(x: x, y: 0))
                    line.addLine(to: CGPoint(x: x + size.height, y: size.height))
                    ctx.stroke(line, with: .color(Color.white.opacity(0.03)), lineWidth: 1)
                    x += spacing
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))

            // Content
            VStack(spacing: 0) {

                Spacer()

                WaxSealIcon()

                Spacer().frame(height: 28)

                Text("SEALED")
                    .font(.bungee(32))
                    .foregroundColor(.white)

                Spacer().frame(height: 14)

                Text("There is a word from God\nfor you tomorrow.\nIt is already written.")
                    .font(.dmSans(15))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 32)

                Spacer()

                // Live countdown
                VStack(spacing: 6) {
                    Text("COME BACK IN")
                        .font(.dmSansMedium(9))
                        .foregroundColor(Color(hex: "E8552B"))
                        .tracking(2.5)

                    Text(timeRemaining)
                        .font(.bungee(20))
                        .foregroundColor(.white)
                        .monospacedDigit()
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.07))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                        )
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color(hex: "1A1410"), lineWidth: 3)
        )
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(hex: "1A1410"))
                .offset(x: 7, y: 9)
        )
        .onAppear {
            timeRemaining = calculateTimeRemaining()
        }
        .onReceive(timer) { _ in
            timeRemaining = calculateTimeRemaining()
        }
    }
}
