//
//  PausedLayer.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/16/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class PausedLayer: SKNode {
    
    private static let BUTTON_DIAMETER: CGFloat = 200
    private static let BUTTON_SIZE = CGSizeMake(BUTTON_DIAMETER, BUTTON_DIAMETER)
    private static let BUTTON_PADDING: CGFloat = 100
    private static let UNPAUSE_IMAGE_NAME = "button-unpause"
    private static let BACK_IMAGE_NAME = "button-back-to-menu"
    private static let BUTTON_Z_POSITION: CGFloat = 2
    
    private static let BACKGROUND_Z_POSITION: CGFloat = 1
    private static let BACKGROUND_ALPHA: CGFloat = 0.5
    
    let unpauseButton: SKSpriteNode
    let backToMenuButton: SKSpriteNode
    
    init(frameSize: CGSize) {
        unpauseButton = SKSpriteNode(imageNamed: PausedLayer.UNPAUSE_IMAGE_NAME)
        unpauseButton.size = PausedLayer.BUTTON_SIZE
        unpauseButton.position = CGPointMake(PausedLayer.BUTTON_DIAMETER / 2 + PausedLayer.BUTTON_PADDING, 0)
        unpauseButton.zPosition = PausedLayer.BUTTON_Z_POSITION
        
        backToMenuButton = SKSpriteNode(imageNamed: PausedLayer.BACK_IMAGE_NAME)
        backToMenuButton.size = PausedLayer.BUTTON_SIZE
        backToMenuButton.position = CGPointMake(-(PausedLayer.BUTTON_DIAMETER / 2 + PausedLayer.BUTTON_PADDING), 0)
        backToMenuButton.zPosition = PausedLayer.BUTTON_Z_POSITION
        
        super.init()
        
        addChild(unpauseButton)
        addChild(backToMenuButton)
        
        let background = SKSpriteNode(color: UIColor.blackColor(), size: frameSize)
        background.zPosition = PausedLayer.BACKGROUND_Z_POSITION
        background.alpha = PausedLayer.BACKGROUND_ALPHA
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
