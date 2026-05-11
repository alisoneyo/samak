import SwiftUI

struct CardFrontView: View {
    let riddle: Riddle
    @ObservedObject var vm: RiddleViewModel
    let index: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 26, style: .continuous)
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: Color(hex: "FF8040"), location: 0.0),
                        .init(color: Color(hex: "E8552B"), location: 0.45),
                        .init(color: Color(hex: "C84A2C"), location: 1.0),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Canvas { ctx, size in
                    let spacing: CGFloat = 13
                    var x: CGFloat = -size.height
                    while x < size.width + size.height {
                        var line = Path()
                        line.move(to: CGPoint(x: x, y: 0))
                        line.addLine(to: CGPoint(x: x + size.height, y: size.height))
                        ctx.stroke(line, with: .color(Color.white.opacity(0.05)), lineWidth: 0.5)
                        x += spacing
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            )
            .overlay(
                RadialGradient(
                    stops: [
                        .init(color: Color(hex: "FFD166").opacity(0.45), location: 0.0),
                        .init(color: Color(hex: "FF8C42").opacity(0.18), location: 0.45),
                        .init(color: .clear, location: 1.0),
                    ],
                    center: .init(x: 0.5, y: 0.36),
                    startRadius: 0,
                    endRadius: 170
                )
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            )
            .overlay(
                VStack(spacing: 0) {

                    Spacer()

                    Image("lantern")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 68, height: 84)

                    Spacer()

                    // Promise box
                    VStack(alignment: .leading, spacing: 10) {

                        Text(vm.isToday(index) ? "TODAY'S PROMISE" : riddle.front.theme.uppercased())
                            .font(.dmSansBold(12))
                            .foregroundColor(Color(hex: "E8552B"))
                            .tracking(2.0)

                        Text(riddle.front.promise)
                            .font(.bungee(24))
                            .foregroundColor(Color(hex: "1A1410"))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(1)
                            .tracking(-1)

                        Text(riddle.front.reference)
                            .font(.dmSansBold(12))
                            .foregroundColor(Color(hex: "E8552B").opacity(0.8))
                            .tracking(1.0)
                            .padding(.top, 2)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "EAE0CC"))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(hex: "1A1410"), lineWidth: 2)
                    )
                    .padding(20)

                    // TURN OVER hint
                    HStack(spacing: 10) {
                        Rectangle()
                            .frame(width: 26, height: 1)
                            .foregroundColor(Color.white.opacity(0.4))
                        Text("TURN OVER")
                            .font(.dmSansMedium(12))
                            .foregroundColor(Color.white.opacity(0.65))
                            .tracking(1.6)
                            .lineLimit(1)
                            .fixedSize()
                        Rectangle()
                            .frame(width: 26, height: 1)
                            .foregroundColor(Color.white.opacity(0.4))
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 24)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(Color(hex: "1A1410"), lineWidth: 3)
            )
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color(hex: "1A1410"))
                    .offset(x: 7, y: 9)
            )
    }
}
