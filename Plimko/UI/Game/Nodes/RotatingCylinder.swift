import Foundation

import SceneKit

final class RotatingCylinder: Cylinder {
    
    init(radius: CGFloat, height: CGFloat, x: CGFloat, z: CGFloat) {
        super.init(radius: radius, height: height, type: .kinematic, x: x, z: z)

        self.name = "rotatingCylinder"
        self.eulerAngles = SCNVector3(-CGFloat.pi / 2, 0, 0)
        self.position = SCNVector3(x, radius, z)
        
        let rotate = SCNAction.rotate(by: (Bool.random() ? .pi * 2 : -.pi * 2), around: SCNVector3(0, 1, 0), duration: 2)
        runAction(SCNAction.repeatForever(rotate))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
