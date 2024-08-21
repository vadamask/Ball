import UIKit

struct Achievement: Codable {
    let id: Int
    let description: String
    let isLocked: Bool
    
    var imageName: String {
        isLocked ? "achiev\(id)lock" : "achiev\(id)"
    }
}
