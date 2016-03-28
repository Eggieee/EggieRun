//
//  Collectable.swift
//  EggieRun
//
//  Created by Liu Yang on 28/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Collectable: SKSpriteNode {
    let type: CollectableType
    let ingredient: Ingredient?
    let condiment: Condiment?
    let followingGapSize: CGFloat
    
    init(ingredientType: Ingredient, gapSize: CGFloat) {
        ingredient = ingredientType
        condiment = nil
        type = .Ingredient
        followingGapSize = gapSize
        let texture = SKTexture(imageNamed: ingredient!.fineImageNamed)
        let size = CGSizeMake(80, 80)
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.categoryBitMask = BitMaskCategory.collectable
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.dynamic = false
        zPosition = 1
    }
    
    init(condimentType: Condiment, gapSize: CGFloat) {
        ingredient = nil
        condiment = condimentType
        type = .Condiment
        followingGapSize = gapSize
        let texture = SKTexture(imageNamed: condiment!.imageNamed)
        let size = CGSizeMake(80, 80)
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.categoryBitMask = BitMaskCategory.collectable
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.dynamic = false
        zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
