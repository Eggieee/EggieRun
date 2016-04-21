//
//  Collectable.swift
//  EggieRun
//
//  Created by Liu Yang on 28/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: Collectable
// Description: SKSpriteNode representing the ingredients and condiments 
// appearing above closets or shelves.

import SpriteKit

class Collectable: SKSpriteNode {
    static let SIZE = CGSizeMake(80, 80)
    
    let type: CollectableType
    let ingredient: Ingredient?
    let condiment: Condiment?
    let followingGapSize: CGFloat
    
    var emitter: SKEmitterNode?
    
    init(ingredientType: Ingredient, gapSize: CGFloat) {
        ingredient = ingredientType
        condiment = nil
        type = .Ingredient
        followingGapSize = gapSize
        super.init(texture: ingredient?.fineTexture, color: UIColor.clearColor(), size: Collectable.SIZE)
        initializePhysicsProperty()
    }
    
    init(condimentType: Condiment, gapSize: CGFloat) {
        ingredient = nil
        condiment = condimentType
        type = .Condiment
        followingGapSize = gapSize
        super.init(texture: condiment?.texture, color: UIColor.clearColor(), size: Collectable.SIZE)
        initializePhysicsProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializePhysicsProperty() {
        physicsBody = SKPhysicsBody(texture: texture!, alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: size)
        physicsBody?.categoryBitMask = BitMaskCategory.collectable
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.dynamic = false
        zPosition = 1
    }
    
    override func removeFromParent() {
        emitter?.removeFromParent()
        super.removeFromParent()
    }
}
