//
//  TrueEndLayer.swift
//  EggieRun
//
//  Created by Liu Yang on 19/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class TrueEndLayer: SKNode {
    private static let Z_POSITION_BACKGROUND: CGFloat = 1
    private static let Z_POSITION_EGGIE_CHICKIE_SHADE: CGFloat = 2
    private static let Z_POSITION_CHICKIE: CGFloat = 3
    private static let Z_POSITION_FILTER: CGFloat = 3
    private static let ALPHA: CGFloat = 0
    private static let HIGHLIGHT_FILTER = CIFilter(name: "CIColorControls", withInputParameters: ["inputBrightness": 1])
    private static let FADE_TIME = 0.25
    private static let ATLAS_TIME_PER_FRAME = 0.25
    private static let CHANGE_REPEAT = 5
    private static let CHANGE_TIME = Double(CHANGE_REPEAT) * 2 * ATLAS_TIME_PER_FRAME
    private static let WAITING_TIME = 1.0
    private static let NAME_EGGIE = "eggie"
    private static let NAME_CHICKIE_SHADE = "chickie_shade"
    private static let NAME_CHICKIE = "chickie"
    private static let NAME_FILTER = "filter"
    private static let TEXTURE_EGGIE = SKTexture(imageNamed: "stand")
    private static let TEXTURE_CHICKIE = SKTexture(imageNamed: "chickie-1")
    private static let TEXTURE_LAY = SKTexture(imageNamed: "chickie-2")
    private static let ENLARGE_ACTION = SKAction.resizeToWidth(250, height: 250, duration: ATLAS_TIME_PER_FRAME)
    private static let SHRINK_ACTION = SKAction.resizeToWidth(50, height: 50, duration: ATLAS_TIME_PER_FRAME)

    private var action: SKAction!
    
    init(frame: CGRect) {
        super.init()
        
        alpha = TrueEndLayer.ALPHA
        
        let background = SKSpriteNode(color: UIColor.blackColor(), size: frame.size)
        background.zPosition = TrueEndLayer.Z_POSITION_BACKGROUND
        background.position = CGPointMake(frame.midX, frame.midY)
        addChild(background)
        
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.zPosition = TrueEndLayer.Z_POSITION_FILTER
        effectNode.filter = TrueEndLayer.HIGHLIGHT_FILTER
        effectNode.name = TrueEndLayer.NAME_FILTER

        let eggieShade = SKSpriteNode(texture: TrueEndLayer.TEXTURE_EGGIE)
        eggieShade.zPosition = TrueEndLayer.Z_POSITION_EGGIE_CHICKIE_SHADE
        eggieShade.position = CGPointMake(frame.midX, frame.midY)
        eggieShade.name = TrueEndLayer.NAME_EGGIE
        
        let chickieShade = SKSpriteNode(texture: TrueEndLayer.TEXTURE_CHICKIE)
        chickieShade.zPosition = TrueEndLayer.Z_POSITION_EGGIE_CHICKIE_SHADE
        chickieShade.position = CGPointMake(frame.midX, frame.midY)
        chickieShade.name = TrueEndLayer.NAME_CHICKIE_SHADE

        effectNode.addChild(eggieShade)
        effectNode.addChild(chickieShade)
        addChild(effectNode)
        
        let chickie = SKSpriteNode(texture: TrueEndLayer.TEXTURE_CHICKIE)
        chickie.zPosition = TrueEndLayer.Z_POSITION_CHICKIE
        chickie.position = CGPointMake(frame.midX, frame.midY)
        chickie.alpha = TrueEndLayer.ALPHA
        chickie.name = TrueEndLayer.NAME_CHICKIE
        addChild(chickie)
        
        var eggieShadeActionsArray = [SKAction]()
        var chickieShadeActionsArray = [SKAction]()
        for _ in 0..<TrueEndLayer.CHANGE_REPEAT {
            eggieShadeActionsArray += [TrueEndLayer.ENLARGE_ACTION, TrueEndLayer.SHRINK_ACTION]
            chickieShadeActionsArray += [TrueEndLayer.SHRINK_ACTION, TrueEndLayer.ENLARGE_ACTION]
        }
        
        let fadeInAction = SKAction.fadeInWithDuration(TrueEndLayer.FADE_TIME)
        let eggieShadeActions = SKAction.runAction(SKAction.runAction(SKAction.sequence(eggieShadeActionsArray), onChildWithName: TrueEndLayer.NAME_EGGIE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let chickieShadeActions = SKAction.runAction(SKAction.runAction(SKAction.sequence(chickieShadeActionsArray), onChildWithName: TrueEndLayer.NAME_CHICKIE_SHADE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let waitChangeAction = SKAction.waitForDuration(TrueEndLayer.CHANGE_TIME)
        let eggieFadeOutChangingAction = SKAction.runAction(SKAction.runAction(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_EGGIE), onChildWithName: TrueEndLayer.NAME_FILTER)
        let waitEggieFadeOutAction = SKAction.waitForDuration(TrueEndLayer.FADE_TIME)
        let chickieAppearAction = SKAction.runAction(SKAction.fadeInWithDuration(TrueEndLayer.FADE_TIME), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        let waitAction = SKAction.waitForDuration(TrueEndLayer.WAITING_TIME)
        let layAction = SKAction.runAction(SKAction.setTexture(TrueEndLayer.TEXTURE_LAY), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        let clearFilterAction = SKAction.runAction(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_FILTER)
        let clearChickieAction = SKAction.runAction(SKAction.removeFromParent(), onChildWithName: TrueEndLayer.NAME_CHICKIE)
        
        action = SKAction.sequence([fadeInAction, SKAction.group([eggieShadeActions, chickieShadeActions]), waitChangeAction, eggieFadeOutChangingAction, waitEggieFadeOutAction, chickieAppearAction, waitAction, layAction, waitAction, SKAction.group([clearFilterAction, clearChickieAction])])
    }
    
    func animate(completion: Void -> Void) {
        runAction(action, completion: completion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}