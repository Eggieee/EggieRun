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
    private static let POT_PADDING: CGFloat = -20.0

    
    let cookerType: Cooker
    var isPassed = false
    var heightPadding: CGFloat = 0.0
    private let baseNode: SKSpriteNode
    private var assistingNode: SKSpriteNode? = nil
    
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
            assistingNode = SKSpriteNode(imageNamed: "pot-lid")
            heightPadding = Obstacle.POT_PADDING
        default:
            fatalError()
        }
        
        super.init()
        zPosition = 2

        scaleNode(baseNode, width: Obstacle.WIDTH)
        baseNode.position.x = baseNode.size.width / 2
        baseNode.position.y = baseNode.size.height / 2
        addChild(baseNode)
        
        if cooker == .Pot {
            scaleNode(assistingNode!, width: Obstacle.WIDTH)
            
            assistingNode!.position.x = assistingNode!.size.width / 2
            assistingNode!.position.y = assistingNode!.size.height / 2 + 80
            addChild(assistingNode!)
            print(assistingNode!.parent)
            
            assistingNode!.physicsBody = SKPhysicsBody(rectangleOfSize: assistingNode!.size)
            assistingNode!.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
            assistingNode!.physicsBody!.contactTestBitMask = BitMaskCategory.hero
            assistingNode!.physicsBody!.collisionBitMask = BitMaskCategory.hero
            assistingNode!.physicsBody!.dynamic = false
        }
        
        if cooker != .Pan {
            baseNode.physicsBody = SKPhysicsBody(rectangleOfSize: baseNode.size)
            baseNode.physicsBody!.categoryBitMask = BitMaskCategory.obstacle
            baseNode.physicsBody!.contactTestBitMask = BitMaskCategory.hero
            baseNode.physicsBody!.collisionBitMask = BitMaskCategory.hero
            baseNode.physicsBody!.dynamic = false
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isDeadly(vector: CGVector, point: CGPoint) -> Bool {
        switch cookerType {
        case .Oven:
            return vector.dx > 0
        case .Pan:
            return false
        default:
            return nodeAtPoint(point) == baseNode || vector.dx < 0
        }
    }
    
    private func scaleNode(node: SKSpriteNode, width: Double) {
        let aspectRatio = Double(node.size.height / node.size.width)
        node.size = CGSize(width: width, height: width * aspectRatio)
    }
}