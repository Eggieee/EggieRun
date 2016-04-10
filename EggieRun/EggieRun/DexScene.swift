//
//  DexScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/20/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexScene: SKScene {
    
    private static let TITLE_TEXT = "Éggdex"
    private static let TITLE_FONT = "Chalkduster"
    private static let TITLE_SIZE = CGFloat(40)
    private static let TITLE_TOP_PADDING = CGFloat(20)
    
    static let BACK_BUTTON_SIZE = CGFloat(80)
    static let TOP_BAR_HEIGHT = CGFloat(80)
    static let GRID_WIDTH = CGFloat(4.0 / 7)
    static let DETAIL_WIDTH = CGFloat(3.0 / 7)
    
    private var buttonBack: SKSpriteNode!
    var gridNode: DexGridNode?
    var detailNode: DexDetailNode?
    
    override func didMoveToView(view: SKView) {
        let titleLabel = SKLabelNode(fontNamed: DexScene.TITLE_FONT)
        titleLabel.text = DexScene.TITLE_TEXT
        titleLabel.fontSize = DexScene.TITLE_SIZE
        titleLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - DexScene.TITLE_SIZE - DexScene.TITLE_TOP_PADDING)
        self.addChild(titleLabel)
        
        buttonBack = SKSpriteNode(imageNamed: "button-return")
        buttonBack.size = CGSize(width: DexScene.BACK_BUTTON_SIZE, height: DexScene.BACK_BUTTON_SIZE)
        buttonBack.position = CGPoint(x: DexScene.BACK_BUTTON_SIZE, y: self.frame.height - DexScene.BACK_BUTTON_SIZE / 2)
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
            self.view?.presentScene(menuScene!, transition: MenuScene.BACK_TRANSITION)
        }
        
        // click on some dishes
        for dishNode in gridNode!.dishNodes {
            if dishNode.containsPoint(touchLocation) {
                if dishNode.activated {
                    for otherDishNode in gridNode!.dishNodes {
                        otherDishNode.selected = false
                    }
                    dishNode.selected = true
                    detailNode!.dish = dishNode.dish
                }
                break
            }
        }
    }
    
    func createDetailNode() {
        detailNode = DexDetailNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width)
        self.addChild(detailNode!)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
