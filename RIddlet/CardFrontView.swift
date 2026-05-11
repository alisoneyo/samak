import SwiftUI

struct CardFrontView: View {
    let riddle: Riddle
    @ObservedObject var vm: RiddleViewModel
    let index: Int

    private var cardDateLabel: String {
        let df = DateFormatter(); df.dateFormat = "EEE · MMM d"
        return df.string(from: vm.date(for: index)).uppercased()
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(hex: "F27B3C"), location: 0.0),
                            .init(color: Color(hex: "E8531A"), location: 0.55),
                            .init(color: Color(hex: "CC3D0A"), location: 1.0),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.22), .clear],
                        center: .init(x: 0.42, y: 0.28),
                        startRadius: 10,
                        endRadius: 200
                    )
                )

            VStack(spacing: 0) {

                HStack {
                    Text("DAY \(vm.dayNumber(for: index))")
                        .font(.dmSansMedium(12))
                        .foregroundColor(.white.opacity(0.75))
                    Spacer()
                    Text(cardDateLabel)
                        .font(.dmSansMedium(12))
                        .foregroundColor(.white.opacity(0.75))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()

                Image(systemName: riddle.icon)
                    .font(.system(size: 68, weight: .light))
                    .foregroundColor(Color.riddletDark.opacity(0.70))
                    .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)

                Spacer()

                VStack(alignment: .leading, spacing: 8) {

                    Text(vm.isToday(index) ? "TODAY'S RIDDLE" : "THE RIDDLE")
                        .font(.dmSansMedium(11))
                        .foregroundColor(Color.riddletOrange)
                        .tracking(1.6)

                    Text("\"\(riddle.question)\"")
                        .font(.dmSansBold(17))
                        .foregroundColor(Color.riddletDark)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(3)

                    if !vm.isFlipped(index) {
                        Divider().padding(.top, 4)
                        Text("— TAP TO REVEAL —")
                            .font(.dmSans(11))
                            .foregroundColor(Color.riddletDark.opacity(0.35))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 2)
                    }
                }
                .padding(18)
                .background(Color.riddletCard)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.riddletDark, lineWidth: 3)
        )
        .shadow(color: Color.riddletDark.opacity(0.85), radius: 0, x: 5, y: 7)
    }
}
