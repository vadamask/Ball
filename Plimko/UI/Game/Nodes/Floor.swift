import SceneKit

final class Floor: SCNNode {
    
    var length: CGFloat {
        (geometry as? SCNBox)?.length ?? 0
    }
    
    var width: CGFloat {
        (geometry as? SCNBox)?.width ?? 0
    }
    
    var height: CGFloat {
        (geometry as? SCNBox)?.height ?? 0
    }
    
    init(width: CGFloat, height: CGFloat, length: CGFloat) {
        super.init()
        
        let material = SCNMaterial()
        material.diffuse.contents = "Floor.scnassets/texture.png"
        material.diffuse.wrapT = .repeat
        material.diffuse.wrapS = .repeat
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(1, Float(length / 10), 1)
        
        let material2 = SCNMaterial()
        material2.diffuse.contents = "Floor.scnassets/texture.png"
        
        let material3 = SCNMaterial()
        material3.diffuse.contents = "Floor.scnassets/texture.png"
        material3.diffuse.wrapT = .repeat
        material3.diffuse.wrapS = .repeat
        material3.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(length / 10), 1, 1)
        
        let geometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        geometry.materials = [
            material2,
            material3,
            SCNMaterial(),
            material3,
            material,
            SCNMaterial()
        ]
        
        let physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        physicsBody.isAffectedByGravity = false
        physicsBody.categoryBitMask = Bitmask.floor
        physicsBody.collisionBitMask = Bitmask.ball | Bitmask.obstacle
        
        self.geometry = geometry
        self.physicsBody = physicsBody
        self.name = "floor"
        self.position = SCNVector3(0, -height / 2, -length / 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
