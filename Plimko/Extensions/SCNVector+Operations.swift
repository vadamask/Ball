import Foundation
import SceneKit

extension SCNVector3 {
    
    static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    
    static func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }
    
    static func +=(left: inout SCNVector3, right: SCNVector3) {
        left = left + right
    }
    
    static func -=(left: inout SCNVector3, right: SCNVector3) {
        left = left - right
    }
}
