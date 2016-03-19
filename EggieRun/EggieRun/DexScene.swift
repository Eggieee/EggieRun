//
//  DexScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/20/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Éggdex"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
