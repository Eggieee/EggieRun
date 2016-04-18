//
//  Platform.swift
//  EggieRun
//
//  Created by Liu Yang on 20/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Closet: SKNode {
    static let GAP_SIZE: CGFloat = 300
    static let BASELINE_HEIGHTS: CGFloat = -200
    static let HEIGHT: CGFloat = 274

    private static let LEFT_IMAGE_NAME = "closet-left"
    private static let MIDDLE_IMAGE_NAMES = "closet-middle"
    private static let RIGHT_IMAGE_NAMES = "closet-right"

    var width: CGFloat = 0.0
    
    init(numOfMidPiece: Int) {
        super.init()
        
        var imageNames = [Closet.LEFT_IMAGE_NAME]
        
        for _ in 0..<numOfMidPiece {
            imageNames.append(Closet.MIDDLE_IMAGE_NAMES)
        }
        imageNames.append(Closet.RIGHT_IMAGE_NAMES)
        
        for imageName in imageNames {
            let texture = SKTexture(imageNamed: imageName)
            let node = SKSpriteNode(texture: texture)
            
            node.position.x = width + node.size.width / 2
            node.position.y = node.size.height / 2
            node.physicsBody = constructPhysicsBodyFor(texture)
            width += node.size.width
            addChild(node)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constructPhysicsBodyFor(texture: SKTexture) -> SKPhysicsBody {
        let body = SKPhysicsBody(texture: texture, alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: texture.size())
        
        body.categoryBitMask = BitMaskCategory.platform
        body.contactTestBitMask = BitMaskCategory.hero
        body.collisionBitMask = BitMaskCategory.hero
        body.dynamic = false
        return body
    }
}