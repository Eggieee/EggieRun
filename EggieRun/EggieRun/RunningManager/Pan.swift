//
//  Pan.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Pan: Obstacle {
    private static let LID_HEIGHT: CGFloat = 80
    private static let LEFT_WIDTH = Obstacle.WIDTH * 0.7
    private static let RIGHT_WIDTH = Obstacle.WIDTH * 0.3
    
    private var left: SKSpriteNode
    private var right: SKSpriteNode
    
    init() {
        left = SKSpriteNode(imageNamed: "pan-left")
        left.scale(Pan.LEFT_WIDTH)
        left.position.x = left.size.width / 2
        left.position.y = left.size.height / 2
        left.physicsBody = SKPhysicsBody(texture: left.texture!, alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: left.size)
        left.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
        left.physicsBody!.contactTestBitMask = BitMaskCategory.hero
        left.physicsBody!.collisionBitMask = BitMaskCategory.hero | BitMaskCategory.obstacle
        left.physicsBody!.dynamic = false
        
        right = SKSpriteNode(imageNamed: "pan-right")
        right.scale(Pan.RIGHT_WIDTH)
        right.position.x = left.size.width + right.size.width / 2
        right.position.y = right.size.height / 2
        
        super.init(cooker: .Pan)
        addChild(left)
        addChild(right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isDeadly(vector: CGVector, point: CGPoint) -> Bool {
        return true
    }
    
    override func animateClose() {
        
    }
}