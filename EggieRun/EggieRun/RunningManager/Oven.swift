//
//  Oven.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Oven: Obstacle {
    private static let PADDING: CGFloat = -27
    
    private var body: SKSpriteNode
    
    init() {
        body = SKSpriteNode(imageNamed: "oven-open")
        body.scale(Obstacle.WIDTH)
        body.position.x = body.size.width / 2
        body.position.y = body.size.height / 2
        body.physicsBody = SKPhysicsBody(rectangleOfSize: body.size)
        body.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
        body.physicsBody!.contactTestBitMask = BitMaskCategory.hero
        body.physicsBody!.collisionBitMask = BitMaskCategory.hero | BitMaskCategory.obstacle
        body.physicsBody!.dynamic = false
        
        super.init(cooker: .Oven)
        heightPadding = Oven.PADDING
        addChild(body)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func isDeadly(vector: CGVector, point: CGPoint) -> Bool {
        return abs(vector.dy) < 0.5
    }
    
    override func animateClose() {
        let atlas = SKTextureAtlas(named: "oven-close.atlas")
        let textures = atlas.textureNames.sort().map({ atlas.textureNamed($0) })
        body.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: Obstacle.ATLAS_TIME_PER_FRAME)))
    }
}