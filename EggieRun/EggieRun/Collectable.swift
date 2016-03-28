//
//  Collectable.swift
//  EggieRun
//
//  Created by Liu Yang on 28/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Collectable: SKSpriteNode {
    private static let SIZE = CGSizeMake(80, 80)
    
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
        super.init(texture: texture, color: UIColor.clearColor(), size: Collectable.SIZE)
        initializePhysicsProperty()
    }
    
    init(condimentType: Condiment, gapSize: CGFloat) {
        ingredient = nil
        condiment = condimentType
        type = .Condiment
        followingGapSize = gapSize
        let texture = SKTexture(imageNamed: condiment!.imageNamed)
        super.init(texture: texture, color: UIColor.clearColor(), size: Collectable.SIZE)
        initializePhysicsProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializePhysicsProperty() {
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.categoryBitMask = BitMaskCategory.collectable
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.dynamic = false
        zPosition = 1
    }
}
