//
//  HeroStab.swift
//  EggieRun
//
//  Created by Liu Yang on 19/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class HeroStab: PRGHero {
    var node = SKSpriteNode(imageNamed: "run_1")
    var innerState: PRGHeroState
    var speed: Int
    var runAtlas = SKTextureAtlas(named: "run.atlas")
    var runFrames: [SKTexture] = [SKTexture]()
    
    init(state: PRGHeroState) {
        self.innerState = state
        speed = 0
        
        let sortedRunTextureNames = runAtlas.textureNames.sort()
        
        for name in sortedRunTextureNames {
            runFrames.append(runAtlas.textureNamed(name))
        }
    }
    
    var state: PRGHeroState {
        get {
            return innerState
        }
        set(newState) {
            innerState = newState
            print("state changed to " + String(innerState))
            if newState == .Standing {
                node.removeAllActions()
            }
            
            if newState == .Running {
                node.removeAllActions()
                node.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runFrames, timePerFrame: 0.05)))
            }
            
            if newState == .Dying {
                node.removeAllActions()
            }
        }
    }
}