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
        
        buttonBack = SKSpriteNode(imageNamed: "button-return")
        buttonBack.size = CGSize(width: 80, height: 80)
        buttonBack.position = CGPoint(x: 80, y: self.frame.height - 40)
        self.addChild(buttonBack)
        
        let leftDex = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width)
        self.addChild(leftDex)
        
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
    
    func makeRightDex(){
        let rightPage = DexDetailNode(dish: DishDataController.singleton.dishes[0], sceneHeight:self.frame.height, sceneWidth:self.frame.width)
        //rightPage.position = CGPoint(x: 11*self.frame.width/14, y:self.frame.height/2-40)
        self.addChild(rightPage)
    }
        

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
