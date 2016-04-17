//
//  Shelf.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Shelf: SKNode {
    static let BASELINE_HEIGHTS: CGFloat = 350
    static let HEIGHT: CGFloat = 88
    
    private static let LEFT_IMAGE_NAME = "shelf-left"
    private static let MIDDLE_IMAGE_NAMES = "shelf-middle"
    private static let RIGHT_IMAGE_NAMES = "shelf-right"
    
    var width: CGFloat = 0.0
    let followingGapSize: CGFloat
    
    init(numOfMidPiece: Int, gapSize: CGFloat) {
        followingGapSize = gapSize
        super.init()
        
        var imageNames = [Shelf.LEFT_IMAGE_NAME]
        
        for _ in 0..<numOfMidPiece {
            imageNames.append(Shelf.MIDDLE_IMAGE_NAMES)
        }
        imageNames.append(Shelf.RIGHT_IMAGE_NAMES)
        
        for imageName in imageNames {
            let node = SKSpriteNode(imageNamed: imageName)
            node.position.x = width + node.size.width / 2
            node.position.y = Shelf.HEIGHT - node.size.height / 2
            width += node.size.width
            addChild(node)
        }
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: Shelf.HEIGHT), center: CGPoint(x: width/2, y: Shelf.HEIGHT/2))
        physicsBody!.categoryBitMask = BitMaskCategory.platform
        physicsBody!.contactTestBitMask = BitMaskCategory.hero
        physicsBody!.collisionBitMask = BitMaskCategory.hero
        physicsBody!.dynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}