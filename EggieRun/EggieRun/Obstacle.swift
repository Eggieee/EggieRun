//
//  Cooker.swift
//  EggieRun
//
//  Created by Liu Yang on 10/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Obstacle: SKNode {
    static let WIDTH = 200.0
    
    private let cookerType: Cooker
    private let baseNode: SKSpriteNode
    
    init(cooker: Cooker) {
        cookerType = cooker
        baseNode = SKSpriteNode(imageNamed: "oven-open")
        super.init()
        
        let aspectRatio = Double(baseNode.size.height / baseNode.size.width)
        baseNode.size = CGSize(width: Obstacle.WIDTH, height: Obstacle.WIDTH * aspectRatio)
        baseNode.position.x = baseNode.size.width / 2
        baseNode.position.y = baseNode.size.height / 2
        addChild(baseNode)
        zPosition = 2
        
        physicsBody = SKPhysicsBody(rectangleOfSize: baseNode.size, center: CGPoint(x: baseNode.size.width/2, y: baseNode.size.height/2))
        physicsBody?.categoryBitMask = BitMaskCategory.obstacle
        physicsBody?.contactTestBitMask = BitMaskCategory.hero
        physicsBody?.collisionBitMask = BitMaskCategory.platform | BitMaskCategory.hero
        physicsBody?.dynamic = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isDeadPoint(point: CGPoint) -> Bool {
        return point.y < position.y + baseNode.size.height
    }
}