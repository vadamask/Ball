import SceneKit

final class Wall: SCNNode {
    
    init(width: CGFloat, z: CGFloat) {
        super.init()
        
        let frontMaterial = SCNMaterial()
        frontMaterial.diffuse.contents = "Wall.scnassets/Wall.png"
        
        let edgeMaterial = SCNMaterial()
        edgeMaterial.diffuse.contents = "Wall.scnassets/Wall.png"
        edgeMaterial.diffuse.wrapS = .repeat
        edgeMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(4, 1, 1)
        
        let geometry = SCNBox(width: width, height: 5, length: 1, chamferRadius: 0)
        geometry.materials = [
            frontMaterial,
            edgeMaterial,
            frontMaterial,
            edgeMaterial,
            edgeMaterial,
            edgeMaterial
        ]
        
        let physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        physicsBody.categoryBitMask = Bitmask.obstacle
        physicsBody.collisionBitMask = Bitmask.ball
        
        self.geometry = geometry
        self.physicsBody = physicsBody
        self.position.z = Float(z)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
