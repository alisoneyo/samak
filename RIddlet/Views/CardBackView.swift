import SwiftUI

struct CardBackView: View {
    let riddle: Riddle
    @ObservedObject var vm: RiddleViewModel
    let index: Int

    var body: some View {
        ZStack(alignment: .topLeading) {

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.riddletCard)

            VStack(alignment: .leading, spacing: 0) {

                Text("THE ANSWER")
                    .font(.dmSansMedium(12))
                    .foregroundColor(Color.riddletDark.opacity(0.45))
                    .tracking(2.5)
                    .padding(.top, 28)

                Text(riddle.answer.uppercased())
                    .font(.bungee(52))
                    .foregroundColor(Color.riddletDark)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)
                    .padding(.top, 10)

                Divider()
                    .padding(.vertical, 20)

                Text("THE RIDDLE")
                    .font(.dmSansMedium(11))
                    .foregroundColor(Color.riddletDark.opacity(0.4))
                    .tracking(1.6)

                Text("\"\(riddle.question)\"")
                    .font(.dmSans(15))
                    .italic()
                    .foregroundColor(Color.riddletDark.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)
                    .padding(.top, 6)

                Spacer()

                Text("tap to flip back")
                    .font(.dmSans(11))
                    .foregroundColor(Color.riddletDark.opacity(0.28))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.riddletDark, lineWidth: 3)
        )
        .shadow(color: Color.riddletDark.opacity(0.85), radius: 0, x: 5, y: 7)
    }
}
