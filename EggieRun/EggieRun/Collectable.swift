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
    let rawValue: Int
    let followingGapSize: CGFloat
    
    init(colletableType: CollectableType, collectableRawValue: Int, gapSize: CGFloat) {
        type = colletableType
        followingGapSize = gapSize
        rawValue = collectableRawValue
        let texture = SKTexture(imageNamed: "tomato")
        let size = texture.size()
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
