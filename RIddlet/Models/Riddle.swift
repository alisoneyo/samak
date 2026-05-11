import Foundation

struct Riddle: Codable, Identifiable {
    let id: Int
    let question: String
    let answer: String
    let icon: String       // SF Symbol name
}
