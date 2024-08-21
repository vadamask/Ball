import SceneKit

final class Thorn: SCNNode {
    
    var bottomRadius: CGFloat {
        (geometry as? SCNCone)?.bottomRadius ?? 0
    }
    
    var height: CGFloat {
        (geometry as? SCNCone)?.height ?? 0
    }
    
    init(bottomRadius: CGFloat, height: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = "Thorn.scnassets/diffuse.png"
        material.normal.contents = "Thorn.scnassets/normal.tif"
        material.roughness.contents = "Thorn.scnassets/roughness.tif"
        material.ambientOcclusion.contents = "Thorn.scnassets/ao.tif"
        
        let geometry = SCNCone(topRadius: 0, bottomRadius: bottomRadius, height: height)
        geometry.materials = [material]
        
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        physicsBody.categoryBitMask = Bitmask.obstacle
        physicsBody.collisionBitMask = Bitmask.ball | Bitmask.obstacle
        
        self.geometry = geometry
        self.physicsBody = physicsBody
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        let up = SCNAction.move(to: SCNVector3(position.x, Float(height / 2), position.z), duration: 1)
        let down = SCNAction.move(to: SCNVector3(position.x, Float(-height / 2), position.z), duration: 1)
        let pause = SCNAction.wait(duration: 1, withRange: 2)
        let action = SCNAction.sequence([pause, up, pause, down])
        
        runAction(.repeatForever(action))
    }
}
