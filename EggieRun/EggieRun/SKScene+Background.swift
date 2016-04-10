//
//  SKScene+Background.swift
//  EggieRun
//
//  Created by Tang Jiahui on 22/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

private var backgroundAssociationKey: UInt8 = 0

extension SKScene {
    var background: SKSpriteNode? {
        get {
            return objc_getAssociatedObject(self, &backgroundAssociationKey) as? SKSpriteNode
        }
        set(newValue) {
            objc_setAssociatedObject(self, &backgroundAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func changeBackground(imageName: String) {
        if background != nil {
            background!.removeFromParent()
        }
        
        background = SKSpriteNode(imageNamed: imageName)
        background!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        background!.zPosition = -1
        background!.size = UIScreen.mainScreen().bounds.size
        
        addChild(background!)
    }
}
