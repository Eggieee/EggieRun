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
    private static let BACKGROUND_IMAGE_NAME = "default-background"
    private static let DISTANCE_LABEL_TEXT = "Distance: %dm"
    private static let HEADER_FONT_SIZE: CGFloat = 30
    private static let EGGIE_X_POSITION: CGFloat = 200
    
    private enum GameState {
        case Ready, Playing, Over
    }
    
    private var eggie: Eggie!
    private var platformFactory: PRGPlatformFactory!
    private var gameState: GameState = .Ready
    private var distanceLabel: SKLabelNode!
    private var distance = 0
    private var platforms = [PRGPlatform]()
    private var lastUpdatedTime: CFTimeInterval!

    override func didMoveToView(view: SKView) {
        changeBackground(GameScene.BACKGROUND_IMAGE_NAME)
        
        initializePhysicsProperties()
        initializeDistanceLabel()
        initializePlatform()
        
        gameReady()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState == .Ready {
            gameStart()
        } else if gameState == .Playing && eggie.state == .Running {
            eggie.state = .Jumping
        } else if gameState == .Over {
            gameReady()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if lastUpdatedTime != nil && currentTime - lastUpdatedTime < GlobalConstants.timePerFrame {
            return
        }
        
        lastUpdatedTime = currentTime
    
        if (gameState == .Ready || gameState == .Over) {
            return
        }
        
        updateDistance()
        eggie.balance()
        
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
            platform.position.x -= CGFloat(eggie.currentSpeed)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (gameState == .Over) {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.scene {
            gameOver()
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.platform {
            if eggie.state == .Jumping {
                eggie.state = .Running
            }
        }
        // todo
        // else if hero collide with collectable, ...
    }
    
    private func initializePhysicsProperties() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, -9.8)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody!.categoryBitMask = BitMaskCategory.scene
        physicsBody!.contactTestBitMask = BitMaskCategory.hero
    }
    
    private func initializeDistanceLabel() {
        distanceLabel = SKLabelNode(fontNamed: GlobalConstants.fontName)
        distanceLabel.fontSize = GameScene.HEADER_FONT_SIZE
        distanceLabel.text = String(format: GameScene.DISTANCE_LABEL_TEXT, distance)
        distanceLabel.position = CGPoint(x: CGRectGetWidth(distanceLabel.frame), y: CGRectGetHeight(frame) - CGRectGetHeight(distanceLabel.frame))
        addChild(distanceLabel)
    }
    
    private func initializePlatform() {
        platformFactory = PlatformFactoryStab()
        let pf = platformFactory.nextPlatform()
        pf.position.x = 0
        pf.position.y = 0
        platforms.append(pf)
        addChild(pf)
    }
    
    private func updateDistance() {
        distance += eggie.currentSpeed
        distanceLabel.text = String(format: GameScene.DISTANCE_LABEL_TEXT, distance)
    }
    
    private func gameReady() {
        if eggie != nil {
            eggie.removeFromParent()
        }
        
        eggie = Eggie(startPosition: CGPoint(x: GameScene.EGGIE_X_POSITION, y: CGRectGetMidY(frame)))
        addChild(eggie)
        gameState = .Ready
    }
    
    private func gameStart() {
        eggie.state = .Running
        gameState = .Playing
    }
    
    private func gameOver() {
        eggie.state = .Dying
        gameState = .Over
    }
}
