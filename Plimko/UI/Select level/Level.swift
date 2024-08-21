import Foundation

struct Level: Codable {
    let id: Int
    let isLocked: Bool
    let rating: Int
    let records: [Record]
    
    var bestResult: Record {
        records.min() ?? Record(id: 1, time: 0, date: Date(), player: Player(id: 0, name: ""))
    }
}

struct Record: Codable, Comparable {
    let id: Int
    let time: Int
    let date: Date
    let player: Player
    
    static func < (lhs: Record, rhs: Record) -> Bool {
        lhs.time < rhs.time
    }
}

struct Player: Codable, Equatable {
    let id: Int
    let name: String
}
