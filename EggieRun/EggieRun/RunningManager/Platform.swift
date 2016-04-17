//
//  Platform.swift
//  EggieRun
//
//  Created by Liu Yang on 20/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Platform: SKNode {
    private static let GAP_SIZE: CGFloat = 300

    var width: CGFloat = 0.0
    let followingGapWidth: CGFloat
    var height: CGFloat = -1
    var baselineHeight: CGFloat
    
    init(type: PlatformType, numOfMidPiece: Int) {
        followingGapWidth = Platform.GAP_SIZE
        baselineHeight = type.height
        
        super.init()
        
        var imageNames = [type.imageNameLeft]
        
        for _ in 0..<numOfMidPiece {
            imageNames.append(type.imageNameMiddle)
        }
        imageNames.append(type.imageNameRight)
        
        for imageName in imageNames {
            let node = SKSpriteNode(imageNamed: imageName)
            if height < 0 {
                height = node.size.height
            }
            node.position.x = width + node.size.width / 2
            node.position.y = height - node.size.height / 2
            width += node.size.width
            addChild(node)
        }
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height), center: CGPoint(x: width/2, y: height/2))
        physicsBody?.categoryBitMask = BitMaskCategory.platform
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.collisionBitMask = BitMaskCategory.hero
        physicsBody?.dynamic = false
    }
    
    init(imageNames: [String], positionY: CGFloat, gapSize: CGFloat) {
        followingGapWidth = gapSize
        baselineHeight = positionY
        super.init()
        for imageName in imageNames {
            let node = SKSpriteNode(imageNamed: imageName)
            if height < 0 {
                height = node.size.height
            }
            node.position.x = width + node.size.width / 2
            node.position.y = height - node.size.height / 2
            width += node.size.width
            addChild(node)
        }

        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height), center: CGPoint(x: width/2, y: height/2))
        physicsBody?.categoryBitMask = BitMaskCategory.platform
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.collisionBitMask = BitMaskCategory.hero
        physicsBody?.dynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}