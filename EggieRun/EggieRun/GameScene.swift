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
        static let distanceLabelText = "Distance: "
        static let headerFontSize: CGFloat = 30
        static let jumpInitialSpeed = CGVectorMake(0, 200)
    }
    
    var hero: PRGHero!
    private var gameState: GameState = .Ready
    private var background: SKSpriteNode?

    override func didMoveToView(view: SKView) {
        setBackground("default-background")
        
        let distanceLabel = SKLabelNode(fontNamed: GlobalConstants.fontName)
        distanceLabel.text = constants.distanceLabelText
        distanceLabel.fontSize = constants.headerFontSize
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

        addChild(hero.node)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, -0.5)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsBody?.categoryBitMask = BitMaskCategory.scene
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameState == .Ready {
            gameState = .Playing
            hero.state = .Running
        }
        
        if hero.state == .Running {
            hero.state = .Jumping
            hero.node.physicsBody!.velocity = constants.jumpInitialSpeed
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (gameState == .Over) {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == (physicsBody?.categoryBitMask)! | (hero.node.physicsBody?.categoryBitMask)! {
            hero.state = .Dying
            gameState = .Over
        }
        
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
}
