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
    private static let EGGIE_CHICKIE_SHADE_Z_POSITION: CGFloat = 2
    private static let CHICKIE_Z_POSITION: CGFloat = 3
    private static let FILTER_Z_POSITION: CGFloat = 3
    private static let ALPHA: CGFloat = 0
    private static let FADE_TIME = 0.25
    private static let CHANGE_REPEAT = 5
    private static let HIGHLIGHT_FILTER = CIFilter(name: "CIColorControls", withInputParameters: ["inputBrightness": 1])
    private static let ATLAS_TIME_PER_FRAME = 0.25
    private static let CHANGE_TIME = Double(CHANGE_REPEAT) * 2 * TrueEndLayer.ATLAS_TIME_PER_FRAME
    private static let WAITING_TIME = 1.0
    private static let NAME_EGGIE = "eggie"
    private static let NAME_CHICKIE_SHADE = "chickie_shade"
    private static let NAME_CHICKIE = "chickie"
    private static let NAME_FILTER = "filter"
    private static let TEXTURE_EGGIE = SKTexture(imageNamed: "stand")
    private static let TEXTURE_CHICKIE = SKTexture(imageNamed: "chickie-1")
    private static let TEXTURE_LAY = SKTexture(imageNamed: "chickie-2")
    private static let ENLARGE_ACTION = SKAction.resizeToWidth(250, height: 250, duration: TrueEndLayer.ATLAS_TIME_PER_FRAME)
    private static let SHRINK_ACTION = SKAction.resizeToWidth(50, height: 50, duration: TrueEndLayer.ATLAS_TIME_PER_FRAME)

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
        effectNode.name = TrueEndLayer.NAME_FILTER

        let eggie = SKSpriteNode(texture: TrueEndLayer.TEXTURE_EGGIE)
        eggie.zPosition = TrueEndLayer.EGGIE_CHICKIE_SHADE_Z_POSITION
        eggie.position = CGPointMake(frame.midX, frame.midY)
        eggie.name = TrueEndLayer.NAME_EGGIE
        
        let chickieShade = SKSpriteNode(texture: TrueEndLayer.TEXTURE_CHICKIE)
        chickieShade.zPosition = TrueEndLayer.EGGIE_CHICKIE_SHADE_Z_POSITION
        chickieShade.position = CGPointMake(frame.midX, frame.midY)
        chickieShade.name = TrueEndLayer.NAME_CHICKIE_SHADE
        
        let chickie = SKSpriteNode(texture: TrueEndLayer.TEXTURE_CHICKIE)
        chickie.zPosition = TrueEndLayer.CHICKIE_Z_POSITION
        chickie.position = CGPointMake(frame.midX, frame.midY)
        chickie.alpha = TrueEndLayer.ALPHA
        chickie.name = TrueEndLayer.NAME_CHICKIE

        effectNode.addChild(eggie)
        effectNode.addChild(chickieShade)
        addChild(effectNode)
        addChild(chickie)
        
        var eggieActionsArray = [SKAction]()
        var chickieActionsArray = [SKAction]()
        for _ in 0..<TrueEndLayer.CHANGE_REPEAT {
            eggieActionsArray += [TrueEndLayer.ENLARGE_ACTION, TrueEndLayer.SHRINK_ACTION]
            chickieActionsArray += [TrueEndLayer.SHRINK_ACTION, TrueEndLayer.ENLARGE_ACTION]
        }
        
        let fadeInAction = SKAction.fadeInWithDuration(TrueEndLayer.FADE_TIME)
        let eggieAction = SKAction.sequence(eggieActionsArray)
        let chickieAction = SKAction.sequence(chickieActionsArray)
        let eggieActions = SKAction.runAction(SKAction.runAction(eggieAction, onChildWithName: TrueEndLayer.NAME_EGGIE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let chickieActions = SKAction.runAction(SKAction.runAction(chickieAction, onChildWithName: TrueEndLayer.NAME_CHICKIE_SHADE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let waitChangeAction = SKAction.waitForDuration(TrueEndLayer.CHANGE_TIME)
        let eggieFadeOutChangingAction = SKAction.runAction(SKAction.runAction(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_EGGIE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let waitChickieFadeInAction = SKAction.waitForDuration(TrueEndLayer.FADE_TIME)
        let chickieAppearAction = SKAction.runAction(SKAction.fadeInWithDuration(TrueEndLayer.FADE_TIME), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        let layAction = SKAction.runAction(SKAction.setTexture(TrueEndLayer.TEXTURE_LAY), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        let clearFilterAction = SKAction.runAction(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_FILTER)
        let clearAction = SKAction.runAction(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        let waitAction = SKAction.waitForDuration(TrueEndLayer.WAITING_TIME)
        
        action = SKAction.sequence([fadeInAction, SKAction.group([eggieActions, chickieActions]), waitChangeAction, eggieFadeOutChangingAction, waitChickieFadeInAction, chickieAppearAction, waitAction, layAction, waitAction, SKAction.group([clearFilterAction, clearAction])])
    }
    
    func animate(completion: Void -> Void) {
        runAction(action, completion: completion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}