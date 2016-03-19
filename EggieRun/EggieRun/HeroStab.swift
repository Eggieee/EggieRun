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
    var state: PRGHeroState
    
    init(state: PRGHeroState) {
        self.state = state
    }
    
    func setState(state: PRGHeroState) {
        self.state = state
        print("state changed to" + String(state))
    }
}