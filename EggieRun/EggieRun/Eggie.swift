//
//  Eggie.swift
//  EggieRun
//
//  Created by Liu Yang on 23/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Eggie: SKSpriteNode {
    var innerState: EggieState
    var runningSpeed = 0
    private var runAtlas = SKTextureAtlas(named: "run.atlas")
    private var jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    private var actions: [EggieState: SKAction] = [EggieState: SKAction]()
    private var balancedXPosition: CGFloat
    
    init(position: CGPoint) {
        let sortedRunTextureNames = self.runAtlas.textureNames.sort()
        let sortedJumpTextureNames = self.jumpAtlas.textureNames.sort()
        let standingTexture = self.runAtlas.textureNamed(sortedRunTextureNames[0])
        let runTextures: [SKTexture]
        let jumpTextures: [SKTexture]
        
        self.innerState = .Standing
        self.balancedXPosition = position.x
        super.init(texture: standingTexture, color: UIColor.clearColor(), size: standingTexture.size())

        runTextures = sortedRunTextureNames.map({ self.runAtlas.textureNamed($0) })
        jumpTextures = sortedJumpTextureNames.map({ self.jumpAtlas.textureNamed($0) })
        
        self.actions[.Standing] = SKAction.setTexture(standingTexture)
        self.actions[.Running] = SKAction.repeatActionForever(SKAction.animateWithTextures(runTextures, timePerFrame: Constants.timePerFrame))
        self.actions[.Jumping] = SKAction.repeatActionForever(SKAction.animateWithTextures(jumpTextures, timePerFrame: Constants.timePerFrame))
        self.actions[.Dying] = SKAction.setTexture(standingTexture)
        
        self.runAction(self.actions[.Standing]!)
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: standingTexture.size())
        self.physicsBody!.categoryBitMask = PRGBitMaskCategory.hero
        self.physicsBody!.contactTestBitMask = PRGBitMaskCategory.scene | PRGBitMaskCategory.collectable | PRGBitMaskCategory.platform
        self.physicsBody!.collisionBitMask = PRGBitMaskCategory.platform | PRGBitMaskCategory.scene
        self.physicsBody!.allowsRotation = false

        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var state: EggieState {
        get {
            return self.innerState
        }
        
        set(newState) {
            if newState == self.innerState {
                return
            }
            
            self.innerState = newState
            self.removeAllActions()
            self.runAction(self.actions[newState]!)
        }
    }
    
    func balance() {
        if self.position.x < balancedXPosition {
            self.position.x += 1
        } else if self.position.x > balancedXPosition {
            self.position.x -= 1
        }
    }
}
