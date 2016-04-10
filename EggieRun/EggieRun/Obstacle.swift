//
//  Cooker.swift
//  EggieRun
//
//  Created by Liu Yang on 10/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Obstacle: SKNode {
    static let WIDTH = 150.0
    
    private let cookerType: Cooker
    
    init(cooker: Cooker) {
        cookerType = cooker
        super.init()
        let node = SKSpriteNode(imageNamed: "oven-open")
        let aspectRatio = Double(node.size.height / node.size.width)
        node.size = CGSize(width: Obstacle.WIDTH, height: Obstacle.WIDTH * aspectRatio)
        node.position.x = node.size.width / 2
        node.position.y = node.size.height / 2
        addChild(node)
        zPosition = 2
        
        physicsBody = SKPhysicsBody(rectangleOfSize: node.size, center: CGPoint(x: node.size.width/2, y: node.size.height/2))
        physicsBody?.categoryBitMask = BitMaskCategory.obstacle
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.collisionBitMask = BitMaskCategory.platform
        physicsBody?.dynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}