import SwiftUI

struct AppHeaderView: View {
    @ObservedObject var vm: RiddleViewModel
    
    private var displayedDate: Date {
        let diff = vm.currentIndex - vm.todayIndex
        return Calendar.current.date(byAdding: .day, value: diff, to: Date()) ?? Date()
    }
    
    private var dayLabel: String {
        let diff = vm.currentIndex - vm.todayIndex
        if diff == 0  { return "TODAY" }
        if diff == -1 { return "YESTERDAY" }
        let df = DateFormatter(); df.dateFormat = "EEE"
        return df.string(from: displayedDate).uppercased()
    }
    
    private var monthDay: String {
        let df = DateFormatter(); df.dateFormat = "MMM d"
        return df.string(from: displayedDate).uppercased()
    }
    var body: some View {
        VStack(spacing: 6) {
            // App logo row
            Image("samaklogo")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.bottom, 28)
        
        // Day counter
        HStack(spacing: 4) {
            Image(systemName: "")
                .font(.system(size: 14, weight: .semibold))
            Text("GOD'S PROMISE FOR:")
                .font(.dmSansBold(13))
        }
        .foregroundColor(Color.riddletDark.opacity(0.45))
        
        // Big date
        HStack(spacing: 0) {
            Text("\(dayLabel), ")
                .font(.bungee(30))
                .foregroundColor(Color.riddletDark)
            Text(monthDay)
                .font(.bungee(30))
                .foregroundColor(Color.riddletOrange)
        }
        .animation(.easeInOut(duration: 0.2), value: vm.currentIndex)
        }
                .padding(.top, 28)
                .padding(.bottom, 28)
            }
        }
