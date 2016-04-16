//
//  Eggie.swift
//  EggieRun
//
//  Created by Liu Yang on 23/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Eggie: SKSpriteNode {
    // Constants
    private static let SPEED_STATIC = 0
    private static let SPEED_RUNNING = 600
    private static let ACCELERATION_JUMPING = CGVectorMake(0, 1000)
    private static let ATLAS_TIME = 0.2
    private static let ATLAS_COUNT = 5
    private static let ATLAS_TIME_PER_FRAME = Eggie.ATLAS_TIME / Double(Eggie.ATLAS_COUNT)
    private static let ATLAS_ACTION_KEY = "atlas"
    
    private var innerCurrentSpeed: Int
    private var innerState: EggieState
    private var actions: [EggieState: SKAction] = [EggieState: SKAction]()
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
        actions[.Jumping] = SKAction.repeatActionForever(SKAction.animateWithTextures(jumpTextures, timePerFrame: Eggie.ATLAS_TIME_PER_FRAME))
        actions[.Dying] = SKAction.setTexture(standingTexture)
        
        runAction(actions[.Standing]!)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: standingTexture.size())
        physicsBody!.categoryBitMask = BitMaskCategory.hero
        physicsBody!.contactTestBitMask = BitMaskCategory.scene | BitMaskCategory.collectable | BitMaskCategory.platform | BitMaskCategory.obstacle
        physicsBody!.collisionBitMask = BitMaskCategory.platform | BitMaskCategory.scene | BitMaskCategory.obstacle
        physicsBody!.allowsRotation = false

        position = startPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var state: EggieState {
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
            case .Jumping:
                physicsBody!.velocity = Eggie.ACCELERATION_JUMPING
            }
        }
    }
    
    var currentSpeed: Int {
        return innerCurrentSpeed
    }
    
    func balance() {
        if position.x < balancedXPosition {
            position.x += 1
        } else if position.x > balancedXPosition {
            position.x -= 1
        }
    }
    
    var canJump: Bool {
        if innerState != .Running {
            return false
        }
        
        let contactingObjects = physicsBody!.allContactedBodies() as [AnyObject]
        for object in contactingObjects {
            if object.categoryBitMask == BitMaskCategory.platform {
                return true
            } else if object.categoryBitMask == BitMaskCategory.obstacle {
                return true
            } else {
                return false
            }
        }
        
        return false
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
