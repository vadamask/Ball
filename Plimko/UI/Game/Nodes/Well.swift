import SceneKit

final class Well: SCNNode {
    
    init(inner: CGFloat, outer: CGFloat, height: CGFloat, z: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.normal.contents = "Obstacles.scnassets/normal.jpg"
        
        let geometry = SCNTube(innerRadius: inner, outerRadius: outer, height: height)
        geometry.materials = [material]
        
        let shape = SCNPhysicsShape(geometry: geometry, options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        
        let physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        physicsBody.isAffectedByGravity = false
        physicsBody.categoryBitMask = Bitmask.well
        physicsBody.collisionBitMask = Bitmask.ball | Bitmask.obstacle
        
        self.geometry = geometry
        self.physicsBody = physicsBody
        self.position = SCNVector3(0, -height / 2 + 0.1, z)
        
        setupFloor(radius: inner, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFloor(radius: CGFloat, height: CGFloat) {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hex: "#03FF8D")
        
        let geometry = SCNCylinder(radius: 0.5, height: 1)
        geometry.materials = [material]
        
        let physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        physicsBody.isAffectedByGravity = false
        physicsBody.categoryBitMask = Bitmask.winPlace
        physicsBody.collisionBitMask = Bitmask.ball
        
        let node = SCNNode(geometry: geometry)
        node.physicsBody = physicsBody
        addChildNode(node)
    }
}
