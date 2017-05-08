//
//  ObjectManager.swift
//  SpaceWars
//
//  Created by Mike Pereira on 09/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class ObjectManager {
    
    private(set) var screenSize: CGSize
    
    private(set) var ownID: Int
    
    private(set) var fieldSize: CGSize
    private(set) var fieldShape: SpacefieldShape
    
    private(set) var client: ClientInterface
    private(set) var idCounter: IDCounter?
    
    private(set) var world: World
    private(set) var background: Background
    private(set) var overlay: Overlay
    private(set) var camera: PlayerCamera
    private(set) var minimap: MiniMap
    
    fileprivate(set) var player: Spaceship?
    fileprivate var spaceships = [Spaceship]()
    fileprivate var enemies = [Spaceship]()
    
    fileprivate var objectDictionary = [Int: GameObject]()
    
    private var pausePanel: SKNode?
    private var pauseButton: PauseButton?
    
    public var paused: Bool = false {
        didSet {
            world.isPaused = paused
            
            if(paused) {
                pauseButton?.setState(.paused)
            } else {
                pauseButton?.setState(.unpaused)
            }
        }
    }
    
    public var centerPoint: CGPoint {
        get {
            if(self.fieldShape == .rect) {
                return CGPoint(x: self.fieldSize.width, y: self.fieldSize.height)/2
            } else {
                return CGPoint(x: self.fieldSize.width, y: self.fieldSize.width)
            }
        }
    }

    init(screenSize: CGSize, ownID: Int, fieldSize: CGSize, fieldShape: SpacefieldShape, client: ClientInterface) {
        self.screenSize = screenSize
        self.ownID = ownID
        self.fieldSize = fieldSize
        self.fieldShape = fieldShape
        self.client = client
        self.idCounter = client.server?.idCounter
        self.world = World()
        self.background = Background()
        self.overlay = Overlay(screenSize)
        self.camera = PlayerCamera()
        self.camera.addChild(overlay)
        self.minimap = MiniMap(size: screenSize/3, fieldSize: fieldSize, fieldShape: fieldShape)
        
        let offset = minimap.calculateAccumulatedFrame()/2
        minimap.position = CGPoint(x: offset.width, y: screenSize.height - offset.height)
        assignToOverlay(obj: minimap)
        
        background.setParallaxReference(ref: camera)
    }
    
    public func attachPauseButton() {
        self.pauseButton?.removeFromParent()
        self.pauseButton?.removeDelegate(self)
        self.pauseButton = PauseButton(shouldSwitch: client.server != nil)
        let offset = pauseButton!.calculateAccumulatedFrame()/2
        pauseButton!.position = CGPoint(x: screenSize.width - offset.width, y: screenSize.height - offset.height)
        pauseButton!.addDelegate(self)
        assignToOverlay(obj: pauseButton!)
    }
    
    public func attachTo(scene: SKScene) {
        world.removeFromParent()
        scene.addChild(world)
    
        background.removeFromParent()
        scene.addChild(background)
        camera.removeFromParent()
    
        scene.camera = self.camera
        scene.addChild(self.camera)
        constrainCamera()
    }
    
    public func pauseGame(name: String?) {
        paused = true
        
        pausePanel?.removeFromParent()
        pausePanel = PausePanel(screenSize: screenSize, name: name)
        assignToOverlay(obj: pausePanel!)
    }
    
    public func resumeGame() {
        paused = false
        pausePanel?.removeFromParent()
        pausePanel = nil
    }
    
    public func constrainCamera() {
        switch fieldShape {
        case .rect:
            camera.constraints = [
                SKConstraint.positionX(SKRange(lowerLimit: 0, upperLimit: fieldSize.width)),
                SKConstraint.positionY(SKRange(lowerLimit: 0, upperLimit: fieldSize.height))
            ]
        case .circle:
            camera.constraints = [
                SKConstraint.distance(SKRange(upperLimit: fieldSize.width * 2), to: self.centerPoint)
            ]
        }
    }
    
    public func assignToMinimap(obj: GameObject) {
        var w: CGFloat = 1
        var u: Bool = false
        if let _ = obj as? Spaceship {
            u = true
            w = 2.5
        }
        switch obj.type {
            case .space_station: u = true; w = 2.4
            case .blackhole: u = true; w = 2.4
        case .laserbeam: u = true; w = 0.8
            case .meteoroid_big: w = 2
            default: break
        }
        self.minimap.addItem(ref: obj, needsUpdate: u, weight: w)
    }
    
    public func assignSpaceship(_ ship: Spaceship) {
        ship.torpedoDelegate = self
        spaceships.append(ship)
        
        if(ship.id == ownID) {
            player = ship
            ship.showIndicators = false
            camera.targetObject = ship
            
            let joystick = Joystick()
            let padding = joystick.calculateAccumulatedFrame()
            joystick.position = CGPoint(x: padding.width, y: padding.height)
            player!.controller = joystick
            assignToOverlay(obj: joystick)
            
            let fireButton = FireButton()
            fireButton.position = CGPoint(x: screenSize.width - padding.width, y: padding.height)
            fireButton.addDelegate(player!)
            assignToOverlay(obj: fireButton)
            
            let healthBar = BarIndicator(displayName: "Shield", currentValue: player!.hp, maxValue: player!.hp_max, size: CGSize(width: 125, height: 15), highColor: .green, lowColor: .red)
            healthBar.position = CGPoint(x: screenSize.width/2, y: padding.height/2)
            assignToOverlay(obj: healthBar)
            player!.hpIndicator = healthBar
            
            let energyBar = BarIndicator(displayName: "Ammo", currentValue: player!.ammoCount, maxValue: player!.ammoCountMax, size: CGSize(width: 125, height: 15), highColor: .blue, lowColor: nil)
            energyBar.position = CGPoint(x: screenSize.width/2, y: padding.height/2 - 20)
            assignToOverlay(obj: energyBar)
            player!.ammoIndicator = energyBar
        }
        
        if(idCounter != nil) {
            let spacestation = Spacestation(idCounter: idCounter!, ownerID: ship.id, pos: getFreeRandomPosition())
            if(ship.id != ownID) {
                spacestation.changeColor(.red)
            }
            assignToWorld(obj: spacestation)
        }
        
        ship.addClickDelegate(self)
        assignToWorld(obj: ship)
    }
    
    public func assignCPUSpaceship(_ enemy: Spaceship) {
        enemy.torpedoDelegate = self
        enemies.append(enemy)
        
        enemy.controller = CPUController(ref: enemy, speedThrottle: 0.1, shootDelay: 3)
        
        enemy.addClickDelegate(self)
        assignToWorld(obj: enemy)
    }
    
    public func assignToWorld(obj: GameObject) {
        objectDictionary[obj.id] = obj
        assignToMinimap(obj: obj)
        world.addChild(obj)
        obj.addItemRemoveDelegate(self)
    }
    
    public func assignToWorld(obj: GameEnvironment) {
        world.addChild(obj)
    }
    
    public func assignToBackground(obj: GameEnvironment) {
        background.addChild(obj)
    }
    
    public func assignToOverlay(obj: SKNode) {
        overlay.addChild(obj)
    }
    
    public func getObjectById(id: Int) -> GameObject? {
        return objectDictionary[id]
    }
    
    public func touchesOverlay(_ touchLocation: CGPoint) -> Bool {
        if(overlay.nodes(at: touchLocation).count > 0) {
            return true
        }
        return false
    }
    
    public func getRandomPosition() -> CGPoint {
        var pos: CGPoint?
        if(self.fieldShape == .rect) {
            let reducedFieldSize = self.fieldSize - Double(Global.Constants.spawnDistanceThreshold)
            pos = CGPoint(x: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(reducedFieldSize.width)),
                           y: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(reducedFieldSize.height)))
        } else {
            repeat {
                pos = CGPoint(x: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(fieldSize.width)*2),
                              y: Int.rand(Global.Constants.spawnDistanceThreshold/2, Int(fieldSize.width)*2))
            } while(pos!.distanceTo(self.centerPoint) > (fieldSize.width - CGFloat(Global.Constants.spawnDistanceThreshold)/2))
        }
        return pos!
    }
    
    public func getFreeRandomPosition() -> CGPoint {
        var pos = getRandomPosition()
        
        // With every failed positioning try, lower the minimal distance threshold
        // in order to decrease execution time on an overfilled space field
        var offset: Int = 0
        while(isCloseToGameObject(pos, Global.Constants.spawnDistanceThreshold - offset)) {
            pos = getRandomPosition()
            offset += 5
        }
        
        return pos
    }
    
    public func isCloseToGameObject(_ p: CGPoint, _ threshold: Int) -> Bool {
        for node in world.children {
            if(node as? GameObject != nil &&
                node.position.distanceTo(p) < threshold) {
                return true
            }
        }
        return false
    }
    
    public func getConfig() -> JSON {
        var config: JSON = []
        
        for (_, obj) in objectDictionary {
            try? config.merge(with: [ obj.getConfig() ])
        }
        
        return config
    }
    
    public func generateWorld(_ objects: [JSON]) {
        let _ = getFreeRandomPosition()
        for obj in objects {
            switch obj["type"].stringValue {
            case "meteoroid1":
                if(idCounter != nil) {
                    assignToWorld(obj: SmallMeteoroid(idCounter: idCounter!, pos: getFreeRandomPosition()))
                } else {
                    assignToWorld(obj: SmallMeteoroid(obj))
                }
            case "meteoroid2":
                if(idCounter != nil) {
                    assignToWorld(obj: BigMeteoroid(idCounter: idCounter!, pos: getFreeRandomPosition()))
                } else {
                    assignToWorld(obj: BigMeteoroid(obj))
                }
            case "dilithium":
                if(idCounter != nil) {
                    assignToWorld(obj: Dilithium(idCounter: idCounter!, pos: getFreeRandomPosition()))
                } else {
                    assignToWorld(obj: Dilithium(obj))
                }
            case "life_orb":
                if(idCounter != nil) {
                    assignToWorld(obj: LifeOrb(idCounter: idCounter!, pos: getFreeRandomPosition()))
                } else {
                    assignToWorld(obj: LifeOrb(obj))
                }
            case "blackhole":
                if(idCounter != nil) {
                    assignToWorld(obj: Blackhole(idCounter: idCounter!, radius: Int.rand(100, 300), pos: getFreeRandomPosition(), spawn_pos: centerPoint))
                } else {
                    assignToWorld(obj: Blackhole(obj))
                }
            case "spacestation":
                let station = Spacestation(obj)
                assignToWorld(obj: station)
                if(station.ownerID != ownID) {
                    station.changeColor(.red)
                }
            case "human":
                if(idCounter != nil) {
                    var id = obj["id"].intValue
                    if(id == 0) {
                        id = idCounter!.nextID()
                    }
                    assignSpaceship(HumanShip(idCounter: idCounter!, id: id, playerName: obj["name"].stringValue, pos: getFreeRandomPosition(), fieldSize: fieldSize, fieldShape: fieldShape))
                } else {
                    assignSpaceship(HumanShip(obj, fieldSize, fieldShape))
                }
            case "robot":
                if(idCounter != nil) {
                    var id = obj["id"].intValue
                    if(id == 0) {
                        id = idCounter!.nextID()
                    }
                    assignSpaceship(RobotShip(idCounter: idCounter!, id: id, playerName: obj["name"].stringValue, pos: getFreeRandomPosition(), fieldSize: fieldSize, fieldShape: fieldShape))
                } else {
                    assignSpaceship(RobotShip(obj, fieldSize, fieldShape))
                }
            case "skeleton":
                if(idCounter != nil) {
                    var id = obj["id"].intValue
                    if(id == 0) {
                        id = idCounter!.nextID()
                    }
                    assignSpaceship(SkeletonShip(idCounter: idCounter!, id: id, playerName: obj["name"].stringValue, pos: getFreeRandomPosition(), fieldSize: fieldSize, fieldShape: fieldShape))
                } else {
                    assignSpaceship(SkeletonShip(obj, fieldSize, fieldShape))
                }
            case "cpu_master":
                if(idCounter != nil) {
                    var id = obj["id"].intValue
                    if(id == 0) {
                        id = idCounter!.nextID()
                    }
                    assignCPUSpaceship(CPUMasterShip(idCounter: idCounter!, id: id, playerName: obj["name"].stringValue, pos: getFreeRandomPosition(), fieldSize: fieldSize, fieldShape: fieldShape))
                } else {
                    assignCPUSpaceship(CPUMasterShip(obj, fieldSize, fieldShape))
                }
            case "cpu_slave":
                if(idCounter != nil) {
                    var id = obj["id"].intValue
                    if(id == 0) {
                        id = idCounter!.nextID()
                    }
                    assignCPUSpaceship(CPUSlaveShip(idCounter: idCounter!, id: id, playerName: obj["name"].stringValue, pos: getFreeRandomPosition(), fieldSize: fieldSize, fieldShape: fieldShape))
                } else {
                    assignCPUSpaceship(CPUSlaveShip(obj, fieldSize, fieldShape))
                }
            case let type:
                print("Unknown object type: \(type)")
            }
        }
        
        for enemy in enemies {
            (enemy.controller as? CPUController)?.setTargets(spaceships)
        }
        
        client.server?.didLoadGame(config: getConfig())
    }
    
    public func didReceiveFire(pid: Int, fid: Int, pos: CGPoint, rot: CGFloat) {
        if let ship = getObjectById(id: pid) as? Spaceship {
            ship.shoot(fid: fid, pos: pos, rot: rot)
        }
    }
    
}

extension ObjectManager: ItemRemovedDelegate {
    
    func didRemove(obj: GameObject) {
        objectDictionary[obj.id] = nil
        
        if(idCounter != nil) {
            if(obj == player) {
                player = nil
            }
            
            if let _ = obj as? Dilithium {
                assignToWorld(obj: Dilithium(idCounter: idCounter!, pos: getFreeRandomPosition()))
            } else if let _ = obj as? LifeOrb {
                assignToWorld(obj: LifeOrb(idCounter: idCounter!, pos: getFreeRandomPosition()))
            } else if let _ = obj as? SmallMeteoroid {
                assignToWorld(obj: SmallMeteoroid(idCounter: idCounter!, pos: getFreeRandomPosition()))
            } else if let obj = obj as? BigMeteoroid {
                if(CGFloat.rand(0, 1) < obj.spwawnRate) {
                    assignToWorld(obj: LifeOrb(idCounter: idCounter!, pos: obj.position))
                }
                assignToWorld(obj: BigMeteoroid(idCounter: idCounter!, pos: getFreeRandomPosition()))
            } else if let ship = obj as? Spaceship {
                spaceships = spaceships.filter({ $0 !== ship })
                enemies = enemies.filter({ $0 !== ship })
            }
        }
    }
    
}

extension ObjectManager: GameObjectClickDelegate {
    
    func didClick(obj: GameObject) {
        if(self.player == nil) {
            camera.targetObject = obj
        }
    }
    
}

extension ObjectManager: NeedsUpdateProtocol {
    
    func update() {
        if(!paused) {
            for ship in self.spaceships {
                ship.update()
            }
            for enemy in self.enemies {
                enemy.update()
            }
        }
    }
    
}

extension ObjectManager: NeedsPhysicsUpdateProtocol {
    
    func didSimulatePhysics() {
        camera.didSimulatePhysics()
        background.didSimulatePhysics()
        minimap.didSimulatePhysics()
    }
    
}

extension ObjectManager: PauseButtonProtocol {
    
    func didClickResume() {
        if(paused) {
            client.server?.didStartGame()
        }
    }
    
    func didClickPause() {
        if(!paused) {
            client.sendPause()
        }
    }
    
}

extension ObjectManager: TorpedoProtocol {
    
    func shootTorpedo(ref: Torpedo, shouldSend: Bool) {
        assignToWorld(obj: ref)
        
        if(shouldSend) {
            client.sendTorpedo(torpedo: ref)
        }
    }
    
}
