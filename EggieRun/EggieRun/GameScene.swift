//
//  GameScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright (c) 2016 Eggieee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private struct constants {
        static let distanceLabelText = "Distance: %dm"
        static let headerFontSize: CGFloat = 30
        static let jumpInitialSpeed = CGVectorMake(0, 600)
        static let heroSpeed = 50
    }
    
    var hero: PRGHero!
    var platformFactory: PRGPlatformFactory!
    private var gameState: PRGGameState = .Ready
    private var background: SKSpriteNode?
    private var distanceLabel: SKLabelNode!
    private var distance = 0
    private var platforms = [PRGPlatform]()

    override func didMoveToView(view: SKView) {
        setBackground("default-background")
        
        distanceLabel = SKLabelNode(fontNamed: GlobalConstants.fontName)
        distanceLabel.fontSize = constants.headerFontSize
        distanceLabel.text = String(format: constants.distanceLabelText, distance)
        distanceLabel.position = CGPoint(x: CGRectGetWidth(distanceLabel.frame),
            y: CGRectGetHeight(self.frame) - CGRectGetHeight(distanceLabel.frame))
        distanceLabel.zPosition = 2
        addChild(distanceLabel)
        
        hero = HeroStab(state: .Standing)
        hero.node.physicsBody = SKPhysicsBody(rectangleOfSize: hero.node.size)
        hero.node.position = CGPoint(x: CGRectGetWidth(distanceLabel.frame) + 100,
            y: CGRectGetMidY(self.frame))
        hero.node.zPosition = 1
        hero.node.physicsBody?.categoryBitMask = PRGBitMaskCategory.hero
        hero.node.physicsBody?.contactTestBitMask = PRGBitMaskCategory.scene |
                                                    PRGBitMaskCategory.collectable |
                                                    PRGBitMaskCategory.platform
        hero.node.physicsBody?.collisionBitMask = PRGBitMaskCategory.platform | PRGBitMaskCategory.scene
        addChild(hero.node)
        
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState == .Ready {
            gameStart()
        } else if gameState == .Playing && hero.state == .Running {
            heroJump()
        } else if gameState == .Over {
            gameReady()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (gameState == .Ready || gameState == .Over) {
            return
        }
        
        updateDistance()
        
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
            platform.position.x -= CGFloat(hero.speed)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (gameState == .Over) {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == PRGBitMaskCategory.hero | PRGBitMaskCategory.scene {
            gameOver()
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == PRGBitMaskCategory.hero | PRGBitMaskCategory.platform {
            if hero.state == .Jumping {
                hero.state = .Running
            }
        }
        // todo
        // else if hero collide with collectable, ...
    }
    
    func setBackground(imageName: String) {
        if background != nil {
            background!.removeFromParent()
        }
        
        background = SKSpriteNode(imageNamed: imageName)
        background!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        background!.zPosition = 0
        background!.size = UIScreen.mainScreen().bounds.size
        
        addChild(background!)
    }
    
    private func updateDistance() {
        distance += hero.speed
        distanceLabel.text = String(format: constants.distanceLabelText, distance)
    }
    
    private func gameReady() {
        hero.node.position = CGPoint(x: CGRectGetWidth(distanceLabel.frame) + 100,
            y: CGRectGetMidY(self.frame))
        gameState = .Ready
    }
    
    private func gameStart() {
        hero.state = .Running
        hero.speed = constants.heroSpeed
        gameState = .Playing
    }
    
    private func gameOver() {
        hero.state = .Dying
        hero.speed = 0
        gameState = .Over
    }
    
    private func heroJump() {
        hero.state = .Jumping
        hero.node.physicsBody!.velocity = constants.jumpInitialSpeed
    }
}
