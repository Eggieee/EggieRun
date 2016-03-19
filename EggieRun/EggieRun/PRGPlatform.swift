//
//  PRGPlatform.swift
//  EggieRun
//
//  Created by Liu Yang on 20/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class PRGPlatform: SKNode {
    var width: CGFloat = 0.0
    let followingGapWidth: CGFloat
    var height: CGFloat = 0
    
    init(imageNames: [String], positionY: CGFloat, followingGapSize: CGFloat) {
        self.followingGapWidth = followingGapSize
        super.init()
        for imageName in imageNames {
            let node = SKSpriteNode(imageNamed: imageName)
            height = node.size.height
            node.position.x = width + node.size.width / 2
            node.position.y = node.size.height / 2
            width += node.size.width
            addChild(node)
        }

        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height), center: CGPoint(x: width/2, y: height/2))
        physicsBody?.categoryBitMask = PRGBitMaskCategory.platform
        physicsBody?.contactTestBitMask = PRGBitMaskCategory.hero
        physicsBody?.collisionBitMask = PRGBitMaskCategory.hero
        physicsBody?.dynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}