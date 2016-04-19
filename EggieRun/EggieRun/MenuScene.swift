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
    static private let MUTE_BUTTON_IMAGENAMED = "mute-button"
    
    static private let START_BUTTON_POSITION = CGPoint(x: 215, y: 420)
    static private let DEX_BUTTON_POSITION = CGPoint(x: 210, y: 270)
    static private let MUTE_BUTTON_OFFSET: CGFloat = 30
    static private let MUTE_BUTTON_SIZE = CGSizeMake(40, 40)
    
    static private let MUTE_BUTTON_ALPHA_ON: CGFloat = 1
    static private let MUTE_BUTTON_ALPHA_OFF: CGFloat = 0.4
    
    static private let TRANSITION = SKTransition.doorsOpenVerticalWithDuration(0.5)
    static let BACK_TRANSITION = SKTransition.doorsCloseVerticalWithDuration(0.5)
    
    static let singleton = MenuScene(fileNamed: "MenuScene")
    
    private var buttonPlay: SKSpriteNode!
    private var buttonDex: SKSpriteNode!
    private var buttonMute: SKSpriteNode!
    
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
        
        buttonMute = SKSpriteNode(imageNamed: MenuScene.MUTE_BUTTON_IMAGENAMED)
        buttonMute.size = MenuScene.MUTE_BUTTON_SIZE
        buttonMute.position = CGPointMake(frame.maxX - MenuScene.MUTE_BUTTON_OFFSET, frame.maxY - MenuScene.MUTE_BUTTON_OFFSET)
        buttonMute.alpha = MenuScene.MUTE_BUTTON_ALPHA_OFF
        self.addChild(buttonMute)
        
        DishDataController.singleton
    }
    
    private func toggleMuted() {
        if BGMPlayer.singleton.muted {
            BGMPlayer.singleton.muted = false
            buttonMute.alpha = MenuScene.MUTE_BUTTON_ALPHA_OFF
        } else {
            BGMPlayer.singleton.muted = true
            buttonMute.alpha = MenuScene.MUTE_BUTTON_ALPHA_ON
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        
        if buttonPlay.containsPoint(touchLocation) {
            let gameScene = GameScene(size: self.size)
            self.view?.presentScene(gameScene, transition: MenuScene.TRANSITION)
        } else if buttonDex.containsPoint(touchLocation) {
            let dexScene = DexScene(size: self.size)
            self.view?.presentScene(dexScene, transition: MenuScene.TRANSITION)
        } else if buttonMute.containsPoint(touchLocation) {
            toggleMuted()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
