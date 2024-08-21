import SceneKit

class Cylinder: SCNNode {
    
    init(radius: CGFloat, height: CGFloat, type: SCNPhysicsBodyType, x: CGFloat, z: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.normal.contents = "Obstacles.scnassets/normal.jpg"
        material.roughness.contents = "Obstacles.scnassets/roughness.jpg"
        
        let geometry = SCNCylinder(radius: radius, height: height)
        geometry.materials = [material]

        let physicsBody = SCNPhysicsBody(type: type, shape: nil)
        physicsBody.categoryBitMask = Bitmask.obstacle
        physicsBody.collisionBitMask = Bitmask.ball | Bitmask.well | Bitmask.obstacle
        physicsBody.isAffectedByGravity = false
        
        self.geometry = geometry
        self.physicsBody = physicsBody
        self.name = "cylinder"
        self.position = SCNVector3(x, height / 2, z)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
