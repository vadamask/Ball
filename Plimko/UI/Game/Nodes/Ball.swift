import SceneKit

final class Ball: SCNNode {
    
    init(radius: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = "Ball.scnassets/\(SkinsService.shared.getChoosenSkin())"
        material.normal.contents = "Ball.scnassets/normal.jpg"
        material.specular.contents = UIColor.white
        
        let geometry = SCNSphere(radius: radius)
        geometry.segmentCount = 36
        geometry.materials = [material]
        
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody.categoryBitMask = Bitmask.ball
        physicsBody.collisionBitMask = Bitmask.floor | Bitmask.winPlace | Bitmask.well |
                                       Bitmask.obstacle | Bitmask.trampoline | Bitmask.throwPlace | Bitmask.repellentWall
        
        physicsBody.contactTestBitMask = Bitmask.winPlace | Bitmask.obstacle | Bitmask.trampoline | Bitmask.throwPlace | Bitmask.repellentWall
        
        self.geometry = geometry
        self.physicsBody = physicsBody
        self.name = "ball"
        self.position = SCNVector3(0, 5, -3.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

