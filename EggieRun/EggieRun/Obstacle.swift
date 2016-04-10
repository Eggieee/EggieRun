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
    private static let OVEN_PADDING: CGFloat = -27.0
    
    let cookerType: Cooker
    var isPassed = false
    var heightPadding: CGFloat = 0.0
    private let baseNode: SKSpriteNode
    
    init(cooker: Cooker) {
        cookerType = cooker
        
        switch cooker {
        case .Oven:
            baseNode = SKSpriteNode(imageNamed: "oven-open")
            heightPadding = Obstacle.OVEN_PADDING
        case .Pan:
            baseNode = SKSpriteNode(imageNamed: "pan")
        case .Pot:
            baseNode = SKSpriteNode(imageNamed: "pot-body")
        default:
            fatalError()
        }
        
        super.init()
        
        let aspectRatio = Double(baseNode.size.height / baseNode.size.width)
        baseNode.size = CGSize(width: Obstacle.WIDTH, height: Obstacle.WIDTH * aspectRatio)
        baseNode.position.x = baseNode.size.width / 2
        baseNode.position.y = baseNode.size.height / 2
        addChild(baseNode)
        zPosition = 2
        
        if cooker != .Pan {
            physicsBody = SKPhysicsBody(rectangleOfSize: baseNode.size, center: CGPoint(x: baseNode.size.width/2, y: baseNode.size.height/2))
            physicsBody?.categoryBitMask = BitMaskCategory.obstacle
            physicsBody?.contactTestBitMask = BitMaskCategory.hero
            physicsBody?.collisionBitMask = BitMaskCategory.hero
            physicsBody?.dynamic = false
            physicsBody!.restitution = 0.0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isDeadly(vector: CGVector) -> Bool {
        if cookerType == .Oven {
            return vector.dx < 0
        } else {
            return false
        }
    }
}