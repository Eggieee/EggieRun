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
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-60)
        self.addChild(myLabel)
        
        let label_temp = SKLabelNode(fontNamed:"Courier")
        label_temp.text = "red button -> back"
        label_temp.fontSize = 12
        label_temp.position = CGPoint(x:CGRectGetMidX(self.frame), y:20)
        self.addChild(label_temp)
        
        buttonBack = SKSpriteNode(imageNamed: "button-return")
        buttonBack.size = CGSize(width: 80, height: 80)
        buttonBack.position = CGPoint(x: 80, y: self.frame.height - 40)
        self.addChild(buttonBack)
        
        makeLeftDex()
        makeRightDex()
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
    
    func makeLeftDex(){
        let leftPage = SKSpriteNode(color:UIColor.grayColor(), size:CGSize(width: 4*self.frame.width/7, height:self.frame.height-80))
        leftPage.position = CGPoint(x: 2*self.frame.width/7, y:self.frame.height/2-40)
        self.addChild(leftPage)
    }
    
    func makeRightDex(){
        let rightPage = SKSpriteNode(color:UIColor.brownColor(),size:CGSize(width: 3*self.frame.width/7, height: self.frame.height-80))
        rightPage.position = CGPoint(x: 11*self.frame.width/14, y:self.frame.height/2-40)
        self.addChild(rightPage)
    }
        

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
