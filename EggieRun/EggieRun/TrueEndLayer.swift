//
//  TrueEndLayer.swift
//  EggieRun
//
//  Created by Liu Yang on 19/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class TrueEndLayer: SKNode {
    
    private static let BACKGROUND_Z_POSITION: CGFloat = 1
    private static let EGGIE_Z_POSITION: CGFloat = 2
    private static let FILTER_Z_POSITION: CGFloat = 3
    private static let ALPHA: CGFloat = 0
    private static let FADE_TIME = 0.25
    private static let HIGHLIGHT_FILTER = CIFilter(name: "CIColorControls", withInputParameters: ["inputBrightness": 1])
    private static let ATLAS_TIME_PER_FRAME = 0.25
    private static let REPEAT = 5

    private var action: SKAction!
    
    init(frame: CGRect) {
        super.init()
        
        alpha = TrueEndLayer.ALPHA
        
        let background = SKSpriteNode(color: UIColor.blackColor(), size: frame.size)
        background.zPosition = TrueEndLayer.BACKGROUND_Z_POSITION
        background.position = CGPointMake(frame.midX, frame.midY)
        addChild(background)
        
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.zPosition = TrueEndLayer.FILTER_Z_POSITION
        effectNode.filter = TrueEndLayer.HIGHLIGHT_FILTER
        effectNode.name = "filter"

        let eggie = SKSpriteNode(imageNamed: "stand")
        eggie.zPosition = TrueEndLayer.EGGIE_Z_POSITION
        eggie.position = CGPointMake(frame.midX, frame.midY)
        eggie.name = "eggie"

        effectNode.addChild(eggie)
        addChild(effectNode)
        
        let fadeInAction = SKAction.fadeInWithDuration(TrueEndLayer.FADE_TIME)
        var textures = [SKTexture]()
        textures.append(SKTexture(imageNamed: "stand"))
        textures.append(SKTexture(imageNamed: "oven-open"))

        let envolveAction = SKAction.runAction(SKAction.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: TrueEndLayer.ATLAS_TIME_PER_FRAME)), onChildWithName: "eggie"), onChildWithName: "filter")
        
        action = SKAction.sequence([fadeInAction, envolveAction])
    }
    
    func animate() {
        runAction(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}