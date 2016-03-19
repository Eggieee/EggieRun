//
//  DexScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/20/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexScene: SKScene {
    
    private var buttonBack: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Éggdex"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        let label_temp = SKLabelNode(fontNamed:"Courier")
        label_temp.text = "red button -> back"
        label_temp.fontSize = 12
        label_temp.position = CGPoint(x:CGRectGetMidX(self.frame), y:20)
        self.addChild(label_temp)
        
        buttonBack = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 160, height: 80))
        buttonBack.position = CGPoint(x: 80, y: self.frame.height - 40)
        self.addChild(buttonBack)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        
        if buttonBack.containsPoint(touchLocation) {
            let menuScene = MenuScene.singleton
            let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
            self.view?.presentScene(menuScene!, transition: transition)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
