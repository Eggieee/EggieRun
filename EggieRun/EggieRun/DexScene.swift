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
    var gridNode: DexGridNode?
    var detailNode: DexDetailNode?
    
    override func didMoveToView(view: SKView) {
        let titleLabel = SKLabelNode(fontNamed:"Chalkduster")
        titleLabel.text = "Éggdex"
        titleLabel.fontSize = 45
        titleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-60)
        self.addChild(titleLabel)
        
        buttonBack = SKSpriteNode(imageNamed: "button-return")
        buttonBack.size = CGSize(width: 80, height: 80)
        buttonBack.position = CGPoint(x: 80, y: self.frame.height - 40)
        self.addChild(buttonBack)
        
        gridNode = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width)
        self.addChild(gridNode!)
        
        createDetailNode()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        
        // back
        if buttonBack.containsPoint(touchLocation) {
            let menuScene = MenuScene.singleton
            let transition = SKTransition.doorsCloseVerticalWithDuration(0.5)
            self.view?.presentScene(menuScene!, transition: transition)
        }
        
        // click on some dishes
        for dishNode in gridNode!.dishNodes {
            if dishNode.containsPoint(touchLocation) {
                for otherDishNode in gridNode!.dishNodes {
                    otherDishNode.selected = false
                }
                dishNode.selected = true
                detailNode!.dish = dishNode.dish
                break
            }
        }
        
    }
    
    func createDetailNode() {
        detailNode = DexDetailNode(sceneHeight:self.frame.height, sceneWidth:self.frame.width)
        //rightPage.position = CGPoint(x: 11*self.frame.width/14, y:self.frame.height/2-40)
        self.addChild(detailNode!)
        // detailNode!.dish = DishDataController.singleton.dishes[0]
    }
        

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
