//
//  MenuScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    static private let START_BUTTON_IMAGENAMED = "start-button"
    static private let DEX_BUTTON_IMAGENAMED = "eggdex-button"
    
    static private let START_BUTTON_POSITION = CGPoint(x: 215, y: 420)
    static private let DEX_BUTTON_POSITION = CGPoint(x: 210, y: 270)
    
    static private let TRANSITION = SKTransition.doorsOpenVerticalWithDuration(0.5)
    static let BACK_TRANSITION = SKTransition.doorsCloseVerticalWithDuration(0.5)
    
    static let singleton = MenuScene(fileNamed: "MenuScene")
    
    private var buttonPlay: SKSpriteNode!
    private var buttonDex: SKSpriteNode!
    
    private var initialized = false
    
    override func didMoveToView(view: SKView) {
        BGMPlayer.singleton.moveToStatus(.Menu)
        
        if initialized {
            return
        }
        initialized = true
        
        changeBackground("menu-background")
        
        buttonPlay = SKSpriteNode(imageNamed: MenuScene.START_BUTTON_IMAGENAMED)
        buttonPlay.position = MenuScene.START_BUTTON_POSITION
        self.addChild(buttonPlay)
        
        buttonDex = SKSpriteNode(imageNamed: MenuScene.DEX_BUTTON_IMAGENAMED)
        buttonDex.position = MenuScene.DEX_BUTTON_POSITION
        self.addChild(buttonDex)
        
        DishDataController.singleton
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        
        if buttonPlay.containsPoint(touchLocation) {
            let gameScene = GameScene(fileNamed: "GameScene")!
            self.view?.presentScene(gameScene, transition: MenuScene.TRANSITION)
        } else if buttonDex.containsPoint(touchLocation) {
            let dexScene = DexScene(size: self.size)
            self.view?.presentScene(dexScene, transition: MenuScene.TRANSITION)
        }
    }
    
    override func willMoveFromView(view: SKView) {
        BGMPlayer.singleton.moveToStatus(nil)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
