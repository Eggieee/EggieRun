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
    static let BASELINE_HEIGHTS: CGFloat = -100
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
            let node = SKSpriteNode(imageNamed: imageName)
            node.position.x = width + node.size.width / 2
            node.position.y = node.size.height / 2
            width += node.size.width
            addChild(node)
        }
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: Closet.HEIGHT), center: CGPoint(x: width/2, y: Closet.HEIGHT/2))
        physicsBody!.categoryBitMask = BitMaskCategory.platform
        physicsBody!.contactTestBitMask = BitMaskCategory.hero
        physicsBody!.collisionBitMask = BitMaskCategory.hero
        physicsBody!.dynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}