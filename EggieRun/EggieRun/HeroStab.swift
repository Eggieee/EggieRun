//
//  HeroStab.swift
//  EggieRun
//
//  Created by Liu Yang on 19/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class HeroStab: PRGHero {
    var node = SKSpriteNode(imageNamed: "egg")
    var innerState: PRGHeroState
    var speed: Int
    
    init(state: PRGHeroState) {
        self.innerState = state
        speed = 0
    }
    
    var state: PRGHeroState {
        get {
            return innerState
        }
        set(newState) {
            innerState = newState
            print("state changed to " + String(innerState))
        }
    }
}