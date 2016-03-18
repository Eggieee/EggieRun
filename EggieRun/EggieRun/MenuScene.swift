//
//  MenuScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMoveToView(view: SKView) {
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
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.doorsOpenVerticalWithDuration(0.5)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
