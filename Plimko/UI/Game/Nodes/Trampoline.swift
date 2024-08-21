import SceneKit

final class Trampoline: SCNNode {
    
    init(radius: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        material.roughness.contents = "Trampoline.scnassets/roughness.png"
        
        let geometry = SCNCylinder(radius: radius, height: 0.05)
        geometry.materials = [material]
        
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody.categoryBitMask = Bitmask.trampoline
        physicsBody.collisionBitMask = Bitmask.ball
        
        self.geometry = geometry
        self.physicsBody = physicsBody
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
