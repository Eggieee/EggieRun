//
//  Pot.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Pot: Obstacle {
    private static let PADDING: CGFloat = -20
    private static let LID_HEIGHT: CGFloat = 80
    
    private var potBody: SKSpriteNode!
    private var potLid: SKSpriteNode!

    init() {
        super.init(cooker: .Pot)
        heightPadding = Pot.PADDING

        potBody = SKSpriteNode(imageNamed: "pot-body")
        potBody.scale(Obstacle.WIDTH)
        potBody.position.x = potBody.size.width / 2
        potBody.position.y = potBody.size.height / 2
        potBody.physicsBody = SKPhysicsBody(rectangleOfSize: potBody.size)
        potBody.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
        potBody.physicsBody!.contactTestBitMask = BitMaskCategory.hero
        potBody.physicsBody!.collisionBitMask = BitMaskCategory.hero | BitMaskCategory.obstacle
        potBody.physicsBody!.dynamic = false
        addChild(potBody)
        
        potLid = SKSpriteNode(imageNamed: "pot-lid")
        potLid.scale(Obstacle.WIDTH)
        potLid!.position.x = potLid!.size.width / 2
        potLid!.position.y = potLid!.size.height / 2 + Pot.LID_HEIGHT
        potLid!.physicsBody = SKPhysicsBody(rectangleOfSize: potLid!.size)
        potLid!.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
        potLid!.physicsBody!.contactTestBitMask = BitMaskCategory.hero
        potLid!.physicsBody!.collisionBitMask = BitMaskCategory.hero | BitMaskCategory.obstacle
        potLid!.physicsBody!.dynamic = false
        addChild(potLid!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isDeadly(vector: CGVector, point: CGPoint) -> Bool {
        return nodeAtPoint(point) == potBody || vector.dx != 0
    }
    
    override func animateClose() {
        potLid!.physicsBody!.dynamic = true
    }
}