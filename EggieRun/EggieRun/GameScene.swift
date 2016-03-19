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
        static let jumpInitialSpeed = CGVectorMake(0, 200)
        static let heroSpeed = 1
    }
    
    var hero: PRGHero!
    private var gameState: GameState = .Ready
    private var background: SKSpriteNode?
    private var distanceLabel: SKLabelNode!
    private var distance = 0

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
        hero.node.physicsBody?.categoryBitMask = BitMaskCategory.hero
        hero.node.physicsBody?.contactTestBitMask = BitMaskCategory.scene | BitMaskCategory.collectable
            | BitMaskCategory.platform

        addChild(hero.node)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, -0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsBody?.categoryBitMask = BitMaskCategory.scene
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState == .Ready {
            gameStart()
        } else if gameState == .Playing && hero.state == .Running {
            heroJump()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        updateDistance()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (gameState == .Over) {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == (physicsBody?.categoryBitMask)! | (hero.node.physicsBody?.categoryBitMask)! {
            gameOver()
        }
        // todo
        // else if hero collide with platform, jumping -> running
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
