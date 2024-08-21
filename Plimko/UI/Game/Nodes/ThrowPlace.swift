import SceneKit

final class ThrowPlace: SCNNode {
    
    init(width: CGFloat, length: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        material.normal.contents = "Obstacles.scnassets/normal.jpg"
        material.roughness.contents = "Obstacles.scnassets/roughness.jpg"
        
        let geometry = SCNBox(width: width, height: 0.05, length: length, chamferRadius: 0)
        geometry.materials = [material]
        
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody.categoryBitMask = Bitmask.throwPlace
        physicsBody.collisionBitMask = Bitmask.ball
        
        self.geometry = geometry
        self.physicsBody = physicsBody
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
