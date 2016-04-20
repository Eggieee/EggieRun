//
//  Eggie.swift
//  EggieRun
//
//  Created by Liu Yang on 23/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: Eggie
// Description: a SKSpriteNode representing the hero of the game who runs and 
// jumps on the platforms, collects ingredients and condiments, as well as dies 
// to make dishes.

import SpriteKit

class Eggie: SKSpriteNode {
    // Constants
    private static let SPEED_STATIC = 0
    private static let SPEED_RUNNING = 600
    private static let ATLAS_TIME = 0.2
    private static let ATLAS_COUNT = 5
    private static let ATLAS_TIME_PER_FRAME = Eggie.ATLAS_TIME / Double(Eggie.ATLAS_COUNT)
    private static let ATLAS_ACTION_KEY = "atlas"
    private static let PHYSICS_BODY_TEXTURE_ID = 3
    
    enum State {
        case Standing, Running, Jumping_1, Jumping_2, Dying
    }
    
    private var innerCurrentSpeed: Int
    private var innerState: State
    private var actions: [State: SKAction] = [State: SKAction]()
    private var balancedXPosition: CGFloat
    
    init(startPosition: CGPoint) {
        let runAtlas = SKTextureAtlas(named: "run.atlas")
        let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
        let sortedRunTextureNames = runAtlas.textureNames.sort()
        let sortedJumpTextureNames = jumpAtlas.textureNames.sort()
        let standingTexture = runAtlas.textureNamed(sortedRunTextureNames[0])
        let runTextures: [SKTexture]
        let jumpTextures: [SKTexture]
        
        innerState = .Standing
        balancedXPosition = startPosition.x
        innerCurrentSpeed = Eggie.SPEED_STATIC
        super.init(texture: standingTexture, color: UIColor.clearColor(), size: standingTexture.size())

        runTextures = sortedRunTextureNames.map({ runAtlas.textureNamed($0) })
        jumpTextures = sortedJumpTextureNames.map({ jumpAtlas.textureNamed($0) })
        
        actions[.Standing] = SKAction.setTexture(standingTexture)
        actions[.Running] = SKAction.repeatActionForever(SKAction.animateWithTextures(runTextures, timePerFrame: Eggie.ATLAS_TIME_PER_FRAME))
        actions[.Jumping_1] = SKAction.repeatActionForever(SKAction.animateWithTextures(jumpTextures, timePerFrame: Eggie.ATLAS_TIME_PER_FRAME))
        actions[.Jumping_2] = actions[.Jumping_1]
        actions[.Dying] = SKAction.setTexture(standingTexture)
        
        runAction(actions[.Standing]!)
        
        physicsBody = SKPhysicsBody(texture: runTextures[Eggie.PHYSICS_BODY_TEXTURE_ID], alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: size)
        physicsBody!.mass = GlobalConstants.EGGIE_MASS
        physicsBody!.categoryBitMask = BitMaskCategory.hero
        physicsBody!.contactTestBitMask = BitMaskCategory.scene | BitMaskCategory.collectable | BitMaskCategory.platform | BitMaskCategory.obstacle
        physicsBody!.collisionBitMask = BitMaskCategory.platform | BitMaskCategory.scene | BitMaskCategory.obstacle
        physicsBody!.allowsRotation = false
        physicsBody!.usesPreciseCollisionDetection = true

        position = startPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var state: State {
        get {
            return innerState
        }
        
        set(newState) {
            if newState == innerState {
                return
            }
            
            innerState = newState
            removeAllActions()
            runAction(actions[newState]!, withKey: Eggie.ATLAS_ACTION_KEY)
            
            switch newState {
            case .Standing, .Dying:
                innerCurrentSpeed = Eggie.SPEED_STATIC
            case .Running:
                innerCurrentSpeed = Eggie.SPEED_RUNNING
            case .Jumping_1, .Jumping_2:
                physicsBody!.velocity.dy = min(physicsBody!.velocity.dy + GlobalConstants.EGGIE_JUMPING_ACCELERATION.dy, GlobalConstants.EGGIE_MAX_Y_SPEED)
            }
        }
    }
    
    var currentSpeed: Int {
        return innerCurrentSpeed
    }
    
    func balance() {
        position.x = balancedXPosition
    }
    
    func pauseAtlas() {
        if let action = actionForKey(Eggie.ATLAS_ACTION_KEY) {
            action.speed = 0
        }
    }
    
    func unpauseAtlas() {
        if let action = actionForKey(Eggie.ATLAS_ACTION_KEY) {
            action.speed = 1
        }
    }
}
