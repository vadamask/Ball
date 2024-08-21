import SceneKit

final class Hammer: SCNNode {
    init(z: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        let geometry = SCNCylinder(radius: 0.5, height: 5)
        geometry.materials = [material]
        
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        
        self.geometry = geometry
        self.physicsBody = physicsBody
        self.position = SCNVector3(0, 5, z)
        self.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 2)
        
        createHammerHead()
        createAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createHammerHead() {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        let geometry = SCNBox(width: 4, height: 2, length: 2, chamferRadius: 0)
        geometry.materials = [material]
        
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody.categoryBitMask = Bitmask.obstacle
        physicsBody.collisionBitMask = Bitmask.ball
        
        let node = SCNNode(geometry: geometry)
        node.physicsBody = physicsBody
        node.position = SCNVector3(0, -3.5, 0)
        
        self.addChildNode(node)
    }
    
    private func createAnimation() {
        let left = SCNAction.rotate(by: -.pi, around: SCNVector3(0, 0, 1), duration: 1)
        let right = SCNAction.rotate(by: .pi, around: SCNVector3(0, 0, 1), duration: 1)
        let pause = SCNAction.wait(duration: 1)
        
        let sequence = SCNAction.sequence([left, pause, right, pause])
        runAction(SCNAction.repeatForever(sequence))
    }
}
