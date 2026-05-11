import Foundation

struct RiddleFront: Codable {
    let promise: String
    let reference: String
    let theme: String
}

struct RiddleBack: Codable {
    let reflection: String
    let prayer: String
}

struct Riddle: Codable, Identifiable {
    let id: Int
    let theme: String
    let reference: String
    let front: RiddleFront
    let back: RiddleBack
}
