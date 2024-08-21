import UIKit
import SceneKit

final class GameViewController: UIViewController {

    private enum Constants {
        static let floorHeight: Float = 5
    }
    
    private enum Direction: Int {
        case left
        case right
        case halfRight
        case halfLeft
        case center
    }
    
    private var sceneView = SCNView()
    
    private lazy var scene: SCNScene = {
        let scene = SCNScene()
        scene.physicsWorld.contactDelegate = self
        scene.background.contents = "Skybox.png"
        return scene
    }()
    
    private var ball: Ball?
    private var floor: Floor?
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#FAFF00")
        label.font = UIFont(name: "Moul-Regular", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let currentLevel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#FAFF00")
        label.font = UIFont(name: "Moul-Regular", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: R.Button.left.rawValue), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let level: Int
    private let accelerometer = DeviceAccelerometer()
    private var timer: Timer?
    private var seconds: Int = 0 {
        didSet {
            timerLabel.text = seconds.description
        }
    }
    
    init(level: Int) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingScreen()
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.loadScene()
        }
    }
    
    private func showLoadingScreen() {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "launchscreen")
        view.addSubview(imageView)
    }
    
    @objc func backButtonTapped() {
        if level == 0 {
            MainRouter.shared.pop(animated: true)
        } else {
            MainRouter.shared.popToMap()
        }
    }
    
    @objc private func updateLabel() {
        seconds += 1
    }
}

//MARK: - UI

extension GameViewController {
    
    private func setupUI() {
        timerLabel.text = level == 0 ? "" : seconds.description
        currentLevel.text = level == 0 ? "" : "Level - " + String(level)
        
        view.addSubview(timerLabel)
        view.addSubview(currentLevel)
        view.addSubview(backButton)
        
        timerLabel
            .activateAnchors()
            .centerXToSuperview()
            .centerYAnchor(to: backButton.centerYAnchor, constant: -10)
            .heightAnchor(20)
        
        currentLevel
            .activateAnchors()
            .centerXToSuperview()
            .centerYAnchor(to: backButton.centerYAnchor, constant: 10)
            .heightAnchor(20)
        
        backButton
            .activateAnchors()
            .dimensionAnchors(width: 50, height: 50)
            .topAnchor(to: view.safeAreaLayoutGuide.topAnchor, constant: 8)
            .leadingAnchor(16)
    }
}

//MARK: - Basic setup

extension GameViewController {
    
    private func loadScene() {
        createBall()
        createCamera()
        createLight()
        generateLevel()
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            sceneView = SCNView(frame: self.view.bounds)
            sceneView.delegate = self
            sceneView.scene = self.scene
            //sceneView.allowsCameraControl = true
            
            UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve]) { [weak self] in
                guard let self else { return }
                self.view.subviews[0].removeFromSuperview()
                self.view.addSubview(sceneView)
            }
            
            setupUI()
            
            accelerometer.start()
            if level != 0 {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
            }
        }
    }
    
    private func createBall() {
        let ball = Ball(radius: 0.4)
        scene.rootNode.addChildNode(ball)
        self.ball = ball
    }
    
    private func createCamera() {
        let camera = SCNCamera()
        
        let replica = SCNReplicatorConstraint(target: ball)
        replica.positionOffset = SCNVector3(0, 10, 10)
        replica.influenceFactor = 0.1
        replica.replicatesOrientation = false
        
        let lookAt = SCNLookAtConstraint(target: ball)
        
        let node = SCNNode()
        node.camera = camera
        node.name = "camera"
        node.constraints = [replica, lookAt]
        scene.rootNode.addChildNode(node)
    }
    
    private func createLight() {
        let light = SCNLight()
        light.type = .omni
        light.intensity = 500
        
        let spotLight = SCNLight()
        spotLight.type = .spot
        spotLight.intensity = 1000
        spotLight.spotOuterAngle = 100
        
        let node1 = SCNNode()
        node1.light = light
        node1.name = "omniLight"
        node1.position = SCNVector3(0, 50, 0)
        
        let node2 = SCNNode()
        node2.light = spotLight
        node2.name = "spotLight"
        let lookAt = SCNLookAtConstraint(target: ball)
        let replica = SCNReplicatorConstraint(target: ball)
        replica.positionOffset = SCNVector3(0, 5, 10)
        node2.constraints = [replica, lookAt]
        
        scene.rootNode.addChildNode(node1)
        scene.rootNode.addChildNode(node2)
    }
}

// MARK: - Level generation

extension GameViewController {
    
    private func generateLevel() {
        if level == 0 {
            createTestLevel()
            return
        }
        
        createFloorWithFinish()
        createObstacles()
    }
    
    private func createFloorWithFinish() {
        switch level {
        case 1...3:
            let floor = Floor(width: 15, height: 5, length: 70)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        case 4...6:
            let floor = Floor(width: 14, height: 5, length: 80)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        case 7...9:
            let floor = Floor(width: 13, height: 5, length: 90)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        case 10...12:
            let floor = Floor(width: 12, height: 5, length: 100)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        case 13...15:
            let floor = Floor(width: 11, height: 5, length: 110)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        case 16...18:
            let floor = Floor(width: 10, height: 5, length: 120)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        case 19...21:
            let floor = Floor(width: 9, height: 5, length: 130)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        case 22...100:
            let floor = Floor(width: 6, height: 5, length: 160)
            let finish = Well(inner: 0.5, outer: 1, height: 5, z: -floor.length - 1)
            scene.rootNode.addChildNode(floor)
            scene.rootNode.addChildNode(finish)
            self.floor = floor
            
        default: break
        }
    }

    private func createObstacles() {
        guard let floor else { return }
        
        let usefulDistance = floor.length - 5
        let distanceBetweenObstacles: CGFloat = 8
        let obstaclesCount = usefulDistance / distanceBetweenObstacles
        
        var z: CGFloat = -8
        
        if (1...3) ~= level {
          
            for _ in 1...Int(obstaclesCount) {
                let randomDirection = Int.random(in: 0...4)
                createWallFromCylinders(count: 10, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                z -= distanceBetweenObstacles
            }
        } 
        
        else if (4...6) ~= level {
          
            for i in 1...Int(obstaclesCount) {
                if i % 2 == 1 {
                    let randomDirection = Int.random(in: 0...4)
                    createWallFromCylinders(count: 8, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                } else {
                    let randomDirection = Int.random(in: 0...4)
                    createRotatingCylinder(direction: Direction(rawValue: randomDirection)!, fromZ: z, height: 6)
                }
                z -= distanceBetweenObstacles
            }
        } 
        
        else if (7...9) ~= level {
          
            for i in 1...Int(obstaclesCount) {
                if i % 3 == 1 {
                    let randomDirection = Int.random(in: 0...4)
                    createWallFromCylinders(count: 8, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                } else if i % 3 == 2 {
                    let randomDirection = Int.random(in: 0...4)
                    createRotatingCylinder(direction: Direction(rawValue: randomDirection)!, fromZ: z, height: 6)
                } else {
                    createThorns(radius: 1.5, height: 3, fromZ: z)
                }
                z -= distanceBetweenObstacles
            }
        }
        
        else if (10...12) ~= level {
          
            for i in 1...Int(obstaclesCount) {
                if i % 4 == 1 {
                    let randomDirection = Int.random(in: 0...4)
                    createWallFromCylinders(count: 7, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                } else if i % 4 == 2 {
                    let randomDirection = Int.random(in: 0...4)
                    createRotatingCylinder(direction: Direction(rawValue: randomDirection)!, fromZ: z, height: 6)
                } else if i % 4 == 3 {
                    createThorns(radius: 1.5, height: 3, fromZ: z)
                } else {
                    createTrampoline(fromZ: z, length: distanceBetweenObstacles)
                }
                z -= distanceBetweenObstacles
            }
        } 
        
        else if (13...15) ~= level {
            
            for i in 1...Int(obstaclesCount) {
                if i % 5 == 1 {
                    let randomDirection = Int.random(in: 0...4)
                    createWallFromCylinders(count: 7, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                } else if i % 5 == 2 {
                    let randomDirection = Int.random(in: 0...4)
                    createRotatingCylinder(direction: Direction(rawValue: randomDirection)!, fromZ: z, height: 5)
                } else if i % 5 == 3 {
                    createThorns(radius: 1.5, height: 3, fromZ: z)
                } else if i % 5 == 4 {
                    createTrampoline(fromZ: z, length: distanceBetweenObstacles)
                } else {
                    createWall(fromZ: z)
                }
                z -= distanceBetweenObstacles
            }
        }
        
        else if (16...18) ~= level {
            
            for i in 1...Int(obstaclesCount) {
                if i % 6 == 1 {
                    let randomDirection = Int.random(in: 0...4)
                    createWallFromCylinders(count: 7, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                } else if i % 6 == 2 {
                    let randomDirection = Int.random(in: 0...4)
                    createRotatingCylinder(direction: Direction(rawValue: randomDirection)!, fromZ: z, height: 4)
                } else if i % 6 == 3 {
                    createThrowPlace(fromZ: z, length: distanceBetweenObstacles / 2)
                } else if i % 6 == 4 {
                    createThorns(radius: 1.3, height: 3, fromZ: z)
                } else if i % 6 == 5 {
                    createTrampoline(fromZ: z, length: distanceBetweenObstacles)
                } else {
                    createWall(fromZ: z)
                }
                z -= distanceBetweenObstacles
            }
        }
        
        
        else if (19...21) ~= level {
            
            for i in 1...Int(obstaclesCount) {
                if i % 7 == 1 {
                    let randomDirection = Int.random(in: 0...4)
                    createWallFromCylinders(count: 7, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                } else if i % 7 == 2 {
                    let randomDirection = Int.random(in: 0...4)
                    createRotatingCylinder(direction: Direction(rawValue: randomDirection)!, fromZ: z, height: 4)
                } else if i % 7 == 3 {
                    createThorns(radius: 1.3, height: 3, fromZ: z)
                } else if i % 7 == 4 {
                    createThrowPlace(fromZ: z, length: distanceBetweenObstacles / 2)
                } else if i % 7 == 5 {
                    createTrampoline(fromZ: z, length: distanceBetweenObstacles)
                } else if i % 7 == 6 {
                    createWall(fromZ: z)
                } else {
                    createHammer(fromZ: z)
                }
                z -= distanceBetweenObstacles
            }
        }
        
        // TODO: добавить потом новые препятствия
        
        else {
            
            for i in 1...Int(obstaclesCount) {
                if i % 7 == 1 {
                    let randomDirection = Int.random(in: 0...4)
                    createWallFromCylinders(count: 5, direction: Direction(rawValue: randomDirection)!, fromZ: z)
                } else if i % 7 == 2 {
                    let randomDirection = Int.random(in: 0...4)
                    createRotatingCylinder(direction: Direction(rawValue: randomDirection)!, fromZ: z, height: 3)
                } else if i % 7 == 3 {
                    createThorns(radius: 0.9, height: 3, fromZ: z)
                } else if i % 7 == 4 {
                    createThrowPlace(fromZ: z, length: distanceBetweenObstacles / 2)
                } else if i % 7 == 5 {
                    createTrampoline(fromZ: z, length: distanceBetweenObstacles)
                } else if i % 7 == 6 {
                    createWall(fromZ: z)
                } else {
                    createHammer(fromZ: z)
                }
                z -= distanceBetweenObstacles
            }
        }
    }
}

// MARK: - Obstacles

extension GameViewController {
    
    private func createWallFromCylinders(count: Int, direction: Direction, fromZ: CGFloat) {
        
        guard let floor else { return }
        
        var x: CGFloat
        var z = fromZ
        
        switch direction {
            
        case .left:
            x = -floor.width / 2 + 0.3
            for _ in 1...count {
                let node = Cylinder(radius: 0.3, height: 3, type: .static, x: x, z: z)
                scene.rootNode.addChildNode(node)
                x += 1
            }
            
        case .right:
            x = floor.width / 2 - 0.3
            for _ in 1...count {
                let node = Cylinder(radius: 0.3, height: 3, type: .static, x: x, z: z)
                scene.rootNode.addChildNode(node)
                x -= 1
            }
            
        case .halfRight:
            x = 0
            for _ in 1...count {
                let node = Cylinder(radius: 0.3, height: 3, type: .static, x: x, z: z)
                scene.rootNode.addChildNode(node)
                x += 0.7
                z -= 0.7
            }
            
        case .halfLeft:
            x = 0
            for _ in 1...count {
                let node = Cylinder(radius: 0.3, height: 3, type: .static, x: x, z: z)
                scene.rootNode.addChildNode(node)
                x -= 0.7
                z -= 0.7
            }
            
        case .center:
            x = -floor.width / 4
            for _ in 1...count {
                let node = Cylinder(radius: 0.3, height: 3, type: .static, x: x, z: z)
                scene.rootNode.addChildNode(node)
                x += 1
            }
        }
    }
    
    private func createRotatingCylinder(direction: Direction, fromZ: CGFloat, height: CGFloat) {
        guard let floor else { return }
        
        let rotatingCylinder = RotatingCylinder(radius: 0.4, height: height, x: 0, z: fromZ)
        switch direction {
            
        case .left:
            rotatingCylinder.position.x = -Float(floor.width) / 4
            
        case .right:
            rotatingCylinder.position.x = Float(floor.width) / 4
            
        case .halfRight:
            rotatingCylinder.position.x = Float(floor.width) / 4
            
        case .halfLeft:
            rotatingCylinder.position.x = -Float(floor.width) / 4
            
        case .center:
            rotatingCylinder.position.x = 0
        }
        
        scene.rootNode.addChildNode(rotatingCylinder)
    }
    
    private func createThorns(radius: CGFloat, height: CGFloat, fromZ: CGFloat) {
        guard let floor else { return }
        
        let thorn1 = Thorn(bottomRadius: radius, height: height)
        let thorn2 = Thorn(bottomRadius: radius, height: height)
        let thorn3 = Thorn(bottomRadius: radius, height: height)
        
        thorn1.position = SCNVector3(-floor.width / 3, -thorn1.height / 2, fromZ)
        thorn2.position = SCNVector3(0, -thorn1.height / 2, fromZ)
        thorn3.position = SCNVector3(floor.width / 3, -thorn1.height / 2, fromZ)
        
        thorn1.eulerAngles = SCNVector3(0, Int.random(in: 0...180), 0)
        thorn2.eulerAngles = SCNVector3(0, Int.random(in: 0...180), 0)
        thorn3.eulerAngles = SCNVector3(0, Int.random(in: 0...180), 0)
        
        [thorn1, thorn2, thorn3].forEach {
            scene.rootNode.addChildNode($0)
            $0.startAnimation()
        }
    }
    
    private func createTrampoline(fromZ: CGFloat, length: CGFloat) {
        guard let floor else { return }
        
        let trampoline = Trampoline(radius: floor.width / 4)
        trampoline.position.z = Float(fromZ - length / 2)
        scene.rootNode.addChildNode(trampoline)
    }
    
    private func createWall(fromZ: CGFloat) {
        guard let floor else { return }
        
        let wall = Wall(width: floor.width, z: fromZ)
        scene.rootNode.addChildNode(wall)
    }
    
    private func createThrowPlace(fromZ: CGFloat, length: CGFloat) {
        guard let floor else { return }
        
        let throwPlace = ThrowPlace(width: floor.width / 2, length: length)
        throwPlace.position.z = Float(fromZ)
        throwPlace.position.x = Float(Int.random(in: -Int(floor.width / 4)...Int(floor.width / 4)))
        scene.rootNode.addChildNode(throwPlace)
    }
    
    private func createHammer(fromZ: CGFloat) {
        let hammer = Hammer(z: fromZ)
        scene.rootNode.addChildNode(hammer)
    }
}

// MARK: - Rating

extension GameViewController {
    
    private var rating: Int {
        switch level {
        case 1...20:
            if seconds > 15 {
                 return 1
            } else if seconds > 12 {
                return 2
            } else {
                return 3
            }
            
        case 10...19:
            if seconds > 10 {
                 return 1
            } else if seconds > 8 {
                return 2
            } else {
                return 3
            }
            
        case 20...29:
            if seconds > 15 {
                 return 1
            } else if seconds > 10 {
                return 2
            } else {
                return 3
            }
            
        case 30...39:
            if seconds > 20 {
                 return 1
            } else if seconds > 15 {
                return 2
            } else {
                return 3
            }
            
        case 40...49:
            if seconds > 25 {
                 return 1
            } else if seconds > 20 {
                return 2
            } else {
                return 3
            }
            
        case 50...59:
            if seconds > 25 {
                 return 1
            } else if seconds > 20 {
                return 2
            } else {
                return 3
            }
            
        case 60...69:
            if seconds > 25 {
                 return 1
            } else if seconds > 20 {
                return 2
            } else {
                return 3
            }
            
        case 70...79:
            if seconds > 25 {
                 return 1
            } else if seconds > 20 {
                return 2
            } else {
                return 3
            }
            
        case 80...89:
            if seconds > 25 {
                 return 1
            } else if seconds > 20 {
                return 2
            } else {
                return 3
            }
            
        case 90...100:
            if seconds > 25 {
                 return 1
            } else if seconds > 20 {
                return 2
            } else {
                return 3
            }
            
        default: return 0
        }
    }
    
}

//MARK: - Render

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        checkFalling()
        updateVelocity()
    }
    
    // MARK: Movement
    private func updateVelocity() {
        if let acceleration = accelerometer.getData()?.acceleration {
            let motionForce = SCNVector3(acceleration.x * 0.3, 0, -acceleration.y * 0.3 - 0.1)
            ball?.physicsBody?.velocity += motionForce
        }
    }
    
    private func checkFalling() {
        
        guard let ball else { return }
        
        if ball.presentation.position.y < -5 {

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                if level == 0 {
                    ball.position = SCNVector3(0, 10, -3.5)
                } else {
                    sceneView.delegate = nil
                    MainRouter.shared.showResultScreen(isWin: false, id: self.level, seconds: seconds)
                }
            }
        }
    }
}

//MARK: - Collisions

extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let nodeA = contact.nodeA.physicsBody?.categoryBitMask
        let nodeB = contact.nodeB.physicsBody?.categoryBitMask
        
        // MARK: Ball and win place
        
        if (nodeA == Bitmask.winPlace && nodeB == Bitmask.ball) || (nodeA == Bitmask.ball && nodeB == Bitmask.winPlace) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                sceneView.delegate = nil
                timer?.invalidate()
                scene.isPaused = true
                accelerometer.stop()
                
                if level == 0 {
                    MainRouter.shared.showTestResult()
                } else {
                    LevelsService.shared.saveResult(level, time: seconds, rating: rating)
                    MainRouter.shared.showResultScreen(isWin: true, id: level, seconds: seconds)
                }
            }
        }
        
        // MARK: Ball and trampoline
        
        if (nodeA == Bitmask.trampoline && nodeB == Bitmask.ball) || (nodeB == Bitmask.trampoline && nodeA == Bitmask.ball) {
            ball?.physicsBody?.applyForce(SCNVector3(0, 4, 0), asImpulse: true)
        }
        
        // MARK: Ball and throw place
        
        if (nodeA == Bitmask.throwPlace && nodeB == Bitmask.ball) || (nodeB == Bitmask.throwPlace && nodeA == Bitmask.ball) {
            ball?.physicsBody?.applyForce(SCNVector3(Bool.random() ? 10 : -10, 2, 0), asImpulse: true)
        }
        
        // MARK: Ball and repellent wall
        
        if (nodeA == Bitmask.repellentWall && nodeB == Bitmask.ball) || (nodeB == Bitmask.repellentWall && nodeA == Bitmask.ball) {
            ball?.physicsBody?.applyForce(SCNVector3(0, 0, -7), asImpulse: true)
        }
    }
}

// MARK: - Test level

extension GameViewController {
    private func createTestLevel() {
        createFloor(width: 17 , height: 10, length: 5, x: 0, y: -5, z: 4)
        createFloor(width: 17 , height: 10, length: 5, x: 0, y: -5, z: 4)
        createFloor(width: 17 , height: 10, length: 9, x: 0, y: -5, z: -4)
        createFloor(width: 8 , height: 10, length: 1, x: -4.5, y: -5, z: 1)
        createFloor(width: 8 , height: 10, length: 1, x: 4.5, y: -5, z: 1)
        createWinBox(width: 1, height: 8, length: 1, x: 0, y: -5, z: 1)
        var counter = 0
        for lineZ in -4...5 {
            if lineZ % 2 == 0 {
                for lineX in -counter...counter {
                    if lineX % 2 == 0 {
                        let cylinder = Cylinder(radius: 0.2, height: 1, type: .static, x: CGFloat(lineX), z: CGFloat(lineZ))
                        cylinder.physicsBody?.isAffectedByGravity = false
                        scene.rootNode.addChildNode(cylinder)
                    } else {
                        let cylinder = Cylinder(radius: 0.2, height: 1, type: .static, x: CGFloat(lineX), z: CGFloat(lineZ) - 1)
                        cylinder.physicsBody?.isAffectedByGravity = false
                        scene.rootNode.addChildNode(cylinder)
                    }
                }
                counter += 2
            }
        }
        createRepellentWall(width: 17, length: 1, x: 0, z: 6)
        
        let camera = scene.rootNode.childNode(withName: "camera", recursively: true)
        if let constraint = camera?.constraints?[0] as? SCNReplicatorConstraint {
            constraint.positionOffset = SCNVector3(0, 20, 10)
        }
        
        if let lightNode = scene.rootNode.childNode(withName: "omniLight", recursively: true) {
            lightNode.position.y = 10
            lightNode.light?.intensity = 2000
        }
        
        if let ball = scene.rootNode.childNode(withName: "ball", recursively: true),
           let material = ball.geometry?.materials.first {
            material.diffuse.contents = "Ball.scnassets/texture1.png"
        }
    }
    
    private func createFloor(width: CGFloat, height: CGFloat, length: CGFloat, x: Float, y: Float, z: Float) {
        
        let basicFloor = SCNNode()
        
        let basicFloorGeometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        basicFloor.geometry = basicFloorGeometry
        basicFloor.position = SCNVector3Make(x, y, z)
        
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = #colorLiteral(red: 0.001925094519, green: 0.08812785894, blue: 0.2028826475, alpha: 1)
        floorMaterial.diffuse.intensity = 1
        floorMaterial.metalness.contents = SCNMaterial.LightingModel.blinn
        
        basicFloorGeometry.materials = [floorMaterial]
        
        basicFloor.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        basicFloor.physicsBody?.isAffectedByGravity = false
        
        scene.rootNode.addChildNode(basicFloor)
    }
    
    private func createWinBox(width: CGFloat, height: CGFloat, length: CGFloat, x: Float, y: Float, z: Float) {
        let winFloor = SCNNode()
      
        let basicFloorGeometry = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        winFloor.geometry = basicFloorGeometry
        winFloor.position = SCNVector3Make(x, y, z)
        
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = #colorLiteral(red: 0, green: 0.6549065113, blue: 0, alpha: 1)
        floorMaterial.diffuse.intensity = 1
        
        basicFloorGeometry.materials = [floorMaterial]
        
        winFloor.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        winFloor.physicsBody?.isAffectedByGravity = false
        winFloor.physicsBody?.categoryBitMask = Bitmask.winPlace
        winFloor.physicsBody?.collisionBitMask = Bitmask.ball
        winFloor.physicsBody?.contactTestBitMask = Bitmask.ball
        
        scene.rootNode.addChildNode(winFloor)
    }
    
    private func createRepellentWall(width: CGFloat, length: CGFloat, x: Float, z: Float) {
        let repellentWall = SCNNode()

        let repellentWallGeometry = SCNBox(width: width, height: 1, length: length, chamferRadius: 0)
        repellentWall.geometry = repellentWallGeometry
        repellentWall.position = SCNVector3Make(x, 0.5, z)

        let repellentWallMaterial = SCNMaterial()
        repellentWallMaterial.diffuse.contents = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        repellentWallMaterial.diffuse.intensity = 1

        repellentWallGeometry.materials = [repellentWallMaterial]

        repellentWall.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        repellentWall.physicsBody?.isAffectedByGravity = false
        
        repellentWall.physicsBody?.categoryBitMask = Bitmask.repellentWall
        repellentWall.physicsBody?.collisionBitMask = Bitmask.ball
        repellentWall.physicsBody?.contactTestBitMask = Bitmask.ball

        scene.rootNode.addChildNode(repellentWall)
    }
}
