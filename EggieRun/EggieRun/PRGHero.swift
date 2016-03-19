//
//  Hero.swift
//  EggieRun
//
//  Created by Liu Yang on 19/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

protocol PRGHero {
    var node: SKSpriteNode { get }
    var state: PRGHeroState { get set }
    var speed: Int { get set }
}
