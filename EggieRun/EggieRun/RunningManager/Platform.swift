//
//  platform.swift
//  EggieRun
//
//  Created by Liu Yang on 21/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Platform: SKNode {
    private enum Type {
        case Closet, Shelf
    }
    
    private static let CLOSET_GAP_SIZE: CGFloat = 300
    private static let LEFT_IMAGE_NAMES: [Type: String] = [.Closet: "closet-left", .Shelf: "shelf-left"]
    private static let MIDDLE_IMAGE_NAMES: [Type: String] = [.Closet: "closet-middle", .Shelf: "shelf-middle"]
    private static let RIGHT_IMAGE_NAMES: [Type: String] = [.Closet: "closet-right", .Shelf: "shelf-right"]
    private static let BASELINE_HEIGHTS: [Type: CGFloat] = [.Closet: -200, .Shelf: 408]
    private static let HEIGHT: [Type: CGFloat] = [.Closet: 274, .Shelf: 50]

    var width: CGFloat = 0.0
    let followingGapSize: CGFloat
    let height: CGFloat
    let baselineHeight: CGFloat
    
    static func makeCloset(numOfMidPiece: Int) -> Platform {
        let imageNames = generateImageNameArray(.Closet, numOfMidPiece: numOfMidPiece)
        return Platform(imageNames: imageNames, gapSize: Platform.CLOSET_GAP_SIZE, platformHeight: Platform.HEIGHT[.Closet]!, platformBaselineHeight: Platform.BASELINE_HEIGHTS[.Closet]!)
    }
    
    static func makeShelf(numOfMidPiece: Int, gapSize: CGFloat) -> Platform {
        let imageNames = generateImageNameArray(.Shelf, numOfMidPiece: numOfMidPiece)
        
        return Platform(imageNames: imageNames, gapSize: gapSize, platformHeight: Platform.HEIGHT[.Shelf]!, platformBaselineHeight: Platform.BASELINE_HEIGHTS[.Shelf]!)
    }
    
    static private func generateImageNameArray(type: Type, numOfMidPiece: Int) -> [String] {
        var imageNames = [Platform.LEFT_IMAGE_NAMES[type]!]
        for _ in 0..<numOfMidPiece {
            imageNames.append(Platform.MIDDLE_IMAGE_NAMES[type]!)
        }
        imageNames.append(Platform.RIGHT_IMAGE_NAMES[type]!)
        
        return imageNames
    }
    
    private init(imageNames: [String], gapSize: CGFloat, platformHeight: CGFloat, platformBaselineHeight: CGFloat) {
        followingGapSize = gapSize
        height = platformHeight
        baselineHeight = platformBaselineHeight
        super.init()
        
        for imageName in imageNames {
            let texture = SKTexture(imageNamed: imageName)
            let node = SKSpriteNode(texture: texture)
            
            node.position.x = width + node.size.width / 2
            node.position.y = node.size.height / 2
            node.physicsBody = constructPhysicsBodyFor(texture)
            width += node.size.width
            addChild(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constructPhysicsBodyFor(texture: SKTexture) -> SKPhysicsBody {
        let body = SKPhysicsBody(texture: texture, alphaThreshold: GlobalConstants.PHYSICS_BODY_ALPHA_THRESHOLD, size: texture.size())
        
        body.categoryBitMask = BitMaskCategory.platform
        body.contactTestBitMask = BitMaskCategory.hero
        body.collisionBitMask = BitMaskCategory.hero
        body.dynamic = false
        return body
    }
}