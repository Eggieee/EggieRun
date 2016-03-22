//
//  GameScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright (c) 2016 Eggieee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Constants
    private let backgroundImageName = "default-background"
    private let distanceLabelText = "Distance: %dm"
    private let headerFontSize: CGFloat = 30
    private let jumpInitialSpeed = CGVectorMake(0, 600)
    private let eggieRunningSpeed = 50
    private let eggieXPosition: CGFloat = 200
    
    private var eggie: Eggie!
    private var platformFactory: PRGPlatformFactory!
    private var gameState: PRGGameState = .Ready
    private var distanceLabel: SKLabelNode!
    private var distance = 0
    private var platforms = [PRGPlatform]()

    override func didMoveToView(view: SKView) {
        changeBackground(backgroundImageName)
        
        self.distanceLabel = SKLabelNode(fontNamed: GlobalConstants.fontName)
        self.distanceLabel.fontSize = self.headerFontSize
        self.distanceLabel.text = String(format: self.distanceLabelText, self.distance)
        self.distanceLabel.position = CGPoint(x: CGRectGetWidth(self.distanceLabel.frame), y: CGRectGetHeight(self.frame) - CGRectGetHeight(self.distanceLabel.frame))
        self.addChild(self.distanceLabel)
        
        platformFactory = PlatformFactoryStab()
        let pf = platformFactory.nextPlatform()
        pf.position.x = 0
        pf.position.y = 0
        platforms.append(pf)
        addChild(pf)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, -9.8)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsBody?.categoryBitMask = PRGBitMaskCategory.scene
        physicsBody?.contactTestBitMask = PRGBitMaskCategory.hero
        
        self.gameReady()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.gameState == .Ready {
            self.gameStart()
        } else if self.gameState == .Playing && self.eggie.state == .Running {
            self.eggieJump()
        } else if self.gameState == .Over {
            self.gameReady()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (self.gameState == .Ready || self.gameState == .Over) {
            return
        }
        
        self.updateDistance()
        self.eggie.balance()
        
        let leftMostPlatform = platforms.first!
        let rightMostPlatform = platforms.last!
        let rightMostPlatformRightEnd = rightMostPlatform.position.x + rightMostPlatform.width + rightMostPlatform.followingGapWidth
        
        if rightMostPlatformRightEnd < UIScreen.mainScreen().bounds.width {
            let pf = platformFactory.nextPlatform()
            pf.position.x = rightMostPlatformRightEnd
            pf.position.y = 0
            platforms.append(pf)
            addChild(pf)
        }
        
        if leftMostPlatform.position.x + rightMostPlatform.width + leftMostPlatform.followingGapWidth < 0 {
            platforms.removeFirst()
            leftMostPlatform.removeFromParent()
        }
        
        for platform in platforms {
            platform.position.x -= CGFloat(eggie.runningSpeed)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (self.gameState == .Over) {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == PRGBitMaskCategory.hero | PRGBitMaskCategory.scene {
            self.gameOver()
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == PRGBitMaskCategory.hero | PRGBitMaskCategory.platform {
            if self.eggie.state == .Jumping {
                self.eggie.state = .Running
            }
        }
        // todo
        // else if hero collide with collectable, ...
    }
    
    private func updateDistance() {
        self.distance += eggie.runningSpeed
        self.distanceLabel.text = String(format: distanceLabelText, distance)
    }
    
    private func gameReady() {
        if self.eggie != nil {
            self.eggie.removeFromParent()
        }
        
        self.eggie = Eggie(position: CGPoint(x: self.eggieXPosition, y: CGRectGetMidY(self.frame)))
        self.addChild(self.eggie)
        self.gameState = .Ready
    }
    
    private func gameStart() {
        self.eggie.state = .Running
        self.eggie.runningSpeed = self.eggieRunningSpeed
        self.gameState = .Playing
    }
    
    private func gameOver() {
        self.eggie.state = .Dying
        self.eggie.runningSpeed = 0
        self.gameState = .Over
    }
    
    private func eggieJump() {
        self.eggie.state = .Jumping
        self.eggie.physicsBody!.velocity = jumpInitialSpeed
    }
}
