//
//  GameScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright (c) 2016 Eggieee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private struct constants {
        static let distanceLabelText = "Distance: "
        static let headerFontSize: CGFloat = 30
    }
    
    var hero: PRGHero!
    var gameState: GameState = .Ready
    private var background: SKSpriteNode?

    override func didMoveToView(view: SKView) {
        setBackground("default-background")
        
        let distanceLabel = SKLabelNode(fontNamed: GlobalConstants.fontName)
        distanceLabel.text = constants.distanceLabelText
        distanceLabel.fontSize = constants.headerFontSize
        distanceLabel.position = CGPoint(x: CGRectGetWidth(distanceLabel.frame),
            y: CGRectGetHeight(self.frame) - CGRectGetHeight(distanceLabel.frame))
        
        addChild(distanceLabel)
        
        hero = HeroStab(state: .Standing)
        hero.node.position = CGPoint(x: CGRectGetWidth(distanceLabel.frame) + 100,
            y: CGRectGetMidY(self.frame))
        hero.node.zPosition = 1
        addChild(hero.node)
        
        physicsWorld.gravity = CGVectorMake(0, -0.5)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameState == .Ready {
            gameState = .Playing
            hero.state = .Running
        }
        
        if hero.state == .Running {
            hero.state = .Jumping
            hero.node.position.y += 10
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
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
