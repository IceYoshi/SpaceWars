//
//  ShipSelection.swift
//  SpaceWars
//
//  Created by Mike Pereira on 04/05/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

protocol ShipSelectionDelegate {
    func didSelectSpaceship(type: String)
    func didEndShipSelection()
}

class ShipSelection: SKNode, NavigationProtocol, StartButtonProtocol {
    
    private var shipSize: CGSize
    lazy private var shipSprites: [SKSpriteNode] = [
        SKSpriteNode(texture: GameTexture.textureDictionary[.human], size: self.shipSize),
        SKSpriteNode(texture: GameTexture.textureDictionary[.robot], size: self.shipSize),
        SKSpriteNode(texture: GameTexture.textureDictionary[.skeleton], size: self.shipSize)
    ]
    private var selectedIndex: Int = 0
    private var screenSize: CGSize
    
    private var nameIndicator: BarIndicator?
    private var hpIndicator: BarIndicator?
    private var dmgIndicator: BarIndicator?
    private var ammoIndicator: BarIndicator?
    private var speedIndicator: BarIndicator?
    private var accIndicator: BarIndicator?
    
    private var selectionDisplay: SelectionDisplay
    private var delegate: ShipSelectionDelegate?
    
    init(screenSize: CGSize, players: [Player], delegate: ShipSelectionDelegate?, canStartGame: Bool) {
        self.shipSize = CGSize(width: screenSize.width*0.1, height: screenSize.width*0.12)
        self.screenSize = screenSize
        
        self.selectionDisplay = SelectionDisplay(screenSize, players)
        super.init()
        
        let shipLayer = SKNode()
        
        addShipSprites(to: shipLayer)
        animateToSelection(shouldAnimate: false)
        
        let navigationButtons = NavigationButtons(screenSize, self)
        navigationButtons.position = CGPoint(x: screenSize.width*0.25, y: screenSize.height*0.8)
        shipLayer.addChild(navigationButtons)
        
        addBarIndicators(to: shipLayer)
        
        self.delegate = delegate
        
        if(canStartGame) {
            let startButton = StartButton(screenSize, self)
            startButton.position = CGPoint(x: screenSize.width*0.25, y: screenSize.height*0.13)
            shipLayer.addChild(startButton)
        } else {
            shipLayer.position = CGPoint(x: 0, y: -screenSize.height*0.05)
        }
        
        self.addChild(shipLayer)
        self.addChild(self.selectionDisplay)
        
        self.run(SKAction.wait(forDuration: 0.5)) {
            self.delegate?.didSelectSpaceship(type: self.getSelectedShipType())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getSelectedShipType() -> String {
        if(selectedIndex == 0) {
            return "human"
        } else if(selectedIndex == 1) {
            return "robot"
        } else {
            return "skeleton"
        }
    }
    
    public func selectPrevious() {
        changeSelected(delta: -1)
    }
    
    public func selectNext() {
        changeSelected(delta: 1)
    }
    
    public func changeSelected(delta: Int) {
        let r = (self.selectedIndex + delta) % shipSprites.count
        self.selectedIndex = r >= 0 ? r : r + shipSprites.count
        animateToSelection(shouldAnimate: true)
        updateBarIndicators()
        
        delegate?.didSelectSpaceship(type: getSelectedShipType())
    }
    
    private func addShipSprites(to: SKNode) {
        for sShip in shipSprites {
            sShip.alpha = 0
            to.addChild(sShip)
        }
    }
    
    public func animateToSelection(shouldAnimate: Bool) {
        let moveInAction = SKAction.move(to: CGPoint(x: screenSize.width/4, y: screenSize.height*0.8), duration: shouldAnimate ? 0.3 : 0)
        let fadeInAction = SKAction.fadeIn(withDuration: shouldAnimate ? 0.3 : 0)
        let scaleInAction = SKAction.scale(to: 1, duration: shouldAnimate ? 0.3 : 0)
        
        let moveOutAction = SKAction.move(to: CGPoint(x: screenSize.width/3, y: screenSize.height*0.9), duration: shouldAnimate ? 0.3 : 0)
        let fadeOutAction = SKAction.fadeOut(withDuration: shouldAnimate ? 0.3 : 0)
        let scaleOutAction = SKAction.scale(to: 1.5, duration: shouldAnimate ? 0.3 : 0)
        
        for (i, sShip) in shipSprites.enumerated() {
            if(sShip.alpha != 0 && i != self.selectedIndex) {
                sShip.run(SKAction.group([moveOutAction, fadeOutAction, scaleOutAction]))
            }
        }
        
        let sShip = self.shipSprites[self.selectedIndex]
        if(sShip.alpha == 0 || sShip.hasActions()) {
            sShip.removeAllActions()
            sShip.setScale(1.5)
            sShip.position = CGPoint(x: screenSize.width/5, y: screenSize.height*0.9)
            sShip.run(SKAction.group([moveInAction, fadeInAction, scaleInAction]))
        }
        
    }
    
    public func addBarIndicators(to: SKNode) {
        let size = CGSize(width: screenSize.width*0.4, height: screenSize.height*0.06)
        let xPos = screenSize.width*0.25
        
        self.nameIndicator = BarIndicator(
            displayName: "Human",
            size: size,
            color: .clear
        )
        self.nameIndicator!.position = CGPoint(x: xPos, y: screenSize.height*0.65)
        to.addChild(self.nameIndicator!)
        
        self.hpIndicator = BarIndicator(
            displayName: "Shield",
            currentValue: 0,
            maxValue: 200,
            size: size,
            highColor: UIColor.green,
            lowColor: UIColor.green.lighter()
        )
        self.hpIndicator!.position = CGPoint(x: xPos, y: screenSize.height*0.58)
        to.addChild(self.hpIndicator!)
        
        self.dmgIndicator = BarIndicator(
            displayName: "Damage",
            currentValue: 0,
            maxValue: 60,
            size: size,
            highColor: UIColor.red,
            lowColor: UIColor.red.lighter()
        )
        self.dmgIndicator!.position = CGPoint(x: xPos, y: screenSize.height*0.51)
        to.addChild(self.dmgIndicator!)
        
        self.ammoIndicator = BarIndicator(
            displayName: "Ammo",
            currentValue: 0,
            maxValue: 50,
            size: size,
            highColor: UIColor.blue,
            lowColor: UIColor.blue.lighter()
        )
        self.ammoIndicator!.position = CGPoint(x: xPos, y: screenSize.height*0.44)
        to.addChild(self.ammoIndicator!)
        
        self.speedIndicator = BarIndicator(
            displayName: "Speed",
            currentValue: 0,
            maxValue: 850,
            size: size,
            highColor: UIColor.magenta,
            lowColor: UIColor.magenta.lighter()
        )
        self.speedIndicator!.position = CGPoint(x: xPos, y: screenSize.height*0.37)
        to.addChild(self.speedIndicator!)
        
        self.accIndicator = BarIndicator(
            displayName: "Acceleration",
            currentValue: 0,
            maxValue: 15,
            size: size,
            highColor: UIColor.purple,
            lowColor: UIColor.purple.lighter()
        )
        self.accIndicator!.position = CGPoint(x: xPos, y: screenSize.height*0.30)
        to.addChild(self.accIndicator!)
        
        updateBarIndicators()
    }
    
    public func updateBarIndicators() {
        if(self.selectedIndex == 0) {
            self.nameIndicator?.displayedName = "Human"
            self.hpIndicator?.value = 150
            self.dmgIndicator?.value = 30
            self.ammoIndicator?.value = 25
            self.speedIndicator?.value = 700
            self.accIndicator?.value = 10
        } else if(self.selectedIndex == 1) {
            self.nameIndicator?.displayedName = "Robot"
            self.hpIndicator?.value = 200
            self.dmgIndicator?.value = 60
            self.ammoIndicator?.value = 15
            self.speedIndicator?.value = 650
            self.accIndicator?.value = 8
        } else {
            self.nameIndicator?.displayedName = "Skeleton"
            self.hpIndicator?.value = 100
            self.dmgIndicator?.value = 20
            self.ammoIndicator?.value = 50
            self.speedIndicator?.value = 850
            self.accIndicator?.value = 15
        }
    }
    
    func didPressStart() {
        delegate?.didEndShipSelection()
    }
    
    public func onShipSelected(id: Int, type: String) {
        self.selectionDisplay.onShipSelected(id: id, type: type)
    }
}
