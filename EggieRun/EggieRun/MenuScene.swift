//
//  MenuScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    static let singleton = MenuScene(fileNamed: "MenuScene")
    
    private var buttonPlay: SKSpriteNode!
    private var buttonDex: SKSpriteNode!
    
    private var initialized = false
    
    override func didMoveToView(view: SKView) {
        if initialized {
            return
        }
        initialized = true
        
        changeBackground("menu-background")
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Eggie Run"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        let label_kakkokari = SKLabelNode(fontNamed:"Chalkduster")
        label_kakkokari.text = "(name subject to change)"
        label_kakkokari.fontSize = 12
        label_kakkokari.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)-45)
        self.addChild(label_kakkokari)
        
        let label_temp = SKLabelNode(fontNamed:"Courier")
        label_temp.text = "left btn -> play, right btn -> éggdex"
        label_temp.fontSize = 12
        label_temp.position = CGPoint(x:CGRectGetMidX(self.frame), y:20)
        self.addChild(label_temp)
        
        buttonPlay = SKSpriteNode(imageNamed: "button-play")
        buttonPlay.position = CGPoint(x: CGRectGetMidX(self.frame) - 140, y: 220)
        self.addChild(buttonPlay)
        
        buttonDex = SKSpriteNode(imageNamed: "button-eggdex")
        buttonDex.position = CGPoint(x: CGRectGetMidX(self.frame) + 140, y: 220)
        self.addChild(buttonDex)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        
        if buttonPlay.containsPoint(touchLocation) {
            let gameScene = GameScene(fileNamed: "GameScene")!
            let transition = SKTransition.doorsOpenVerticalWithDuration(0.5)
            self.view?.presentScene(gameScene, transition: transition)
        } else if buttonDex.containsPoint(touchLocation) {
            let dexScene = DexScene(size: self.size)
            let transition = SKTransition.doorsOpenVerticalWithDuration(0.5)
            self.view?.presentScene(dexScene, transition: transition)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
