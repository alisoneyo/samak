import SwiftUI

struct CardBackView: View {
    let riddle: Riddle
    @ObservedObject var vm: RiddleViewModel
    let index: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: "FFF8E8"), location: 0.0),
                            .init(color: Color(hex: "F1E9DA"), location: 1.0),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Canvas { ctx, size in
                let spacing: CGFloat = 13
                var x: CGFloat = -size.height
                while x < size.width + size.height {
                    var line = Path()
                    line.move(to: CGPoint(x: x, y: 0))
                    line.addLine(to: CGPoint(x: x + size.height, y: size.height))
                    ctx.stroke(line, with: .color(Color(hex: "1A1410").opacity(0.04)), lineWidth: 1)
                    x += spacing
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))

            VStack(alignment: .leading, spacing: 0) {

                Text(riddle.front.theme.uppercased())
                    .font(.dmSansMedium(12))
                    .foregroundColor(Color(hex: "E8552B"))
                    .tracking(2.5)

                Text(riddle.back.reflection)
                    .font(.dmSans(20))
                    .foregroundColor(Color(hex: "1A1410"))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(5)
                    .padding(.top, 14)

                Spacer()

                Rectangle()
                    .fill(Color(hex: "1A1410").opacity(0.15))
                    .frame(height: 1)
                    .padding(.bottom, 16)

                Text("PRAYER")
                    .font(.dmSansMedium(12))
                    .foregroundColor(Color(hex: "1A1410").opacity(0.45))
                    .tracking(2.0)
                    .padding(.bottom, 8)

                Text(riddle.back.prayer)
                    .font(.dmSans(16))
                    .italic()
                    .foregroundColor(Color(hex: "1A1410").opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)

                Spacer()
                    .frame(maxHeight: 20)

                Text(riddle.front.reference)
                    .font(.dmSansMedium(14))
                    .foregroundColor(Color(hex: "E8552B").opacity(0.7))
                    .tracking(1.0)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 28)
            .padding(.top, 28)
            .padding(.bottom, 24)
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
    }
}
