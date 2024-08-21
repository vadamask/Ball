import Foundation

enum Bitmask {
    static let ball =       1 << 0
    static let obstacle =   1 << 1
    static let floor =      1 << 2
    static let winPlace =   1 << 3
    static let well =       1 << 4
    static let trampoline = 1 << 5
    static let throwPlace = 1 << 6
    static let repellentWall = 1 << 7
}
