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
    
    private var body: SKSpriteNode!
    private var lid: SKSpriteNode?
    
    init() {
        super.init(cooker: .Pan)
        
        body = SKSpriteNode(imageNamed: "pan")
        body.scale(Obstacle.WIDTH)
        body.position.x = body.size.width / 2
        body.position.y = body.size.height / 2
        body.physicsBody = SKPhysicsBody(rectangleOfSize: body.size)
        body.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
        body.physicsBody!.contactTestBitMask = BitMaskCategory.hero
        body.physicsBody!.collisionBitMask = BitMaskCategory.hero | BitMaskCategory.obstacle
        body.physicsBody!.dynamic = false
        addChild(body)
        
//        lid = SKSpriteNode(imageNamed: "pot-lid")
//        lid.scale(Obstacle.WIDTH)
//        lid!.position.x = lid!.size.width / 2
//        lid!.position.y = lid!.size.height / 2 + Pot.LID_HEIGHT
//        lid!.physicsBody = SKPhysicsBody(rectangleOfSize: lid!.size)
//        lid!.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
//        lid!.physicsBody!.contactTestBitMask = BitMaskCategory.hero
//        lid!.physicsBody!.collisionBitMask = BitMaskCategory.hero | BitMaskCategory.obstacle
//        lid!.physicsBody!.dynamic = false
//        addChild(lid!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isDeadly(vector: CGVector, point: CGPoint) -> Bool {
        return false
    }
    
    override func animateClose() {
        
    }
}