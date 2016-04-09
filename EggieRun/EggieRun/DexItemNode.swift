//
//  DexItemNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexItemNode: SKNode {
    static private let IMAGE_RATIO = CGFloat(1.5)
    
    let dish: Dish
    var selected = false {
        didSet {
            if selected {
                self.alpha = 1.0
            } else {
                self.alpha = 0.5
            }
        }
    }
    
    init(dish: Dish, xPosition: CGFloat, yPosition: CGFloat, size: CGFloat) {
        self.dish = dish
        super.init()
        self.alpha = 0.5
        
        let backgroundNode = SKSpriteNode(imageNamed: "item-background")
        backgroundNode.position = CGPoint(x: xPosition, y: yPosition)
        backgroundNode.size = CGSize(width: size, height: size)
        backgroundNode.zPosition = 1
        
        let dishImageNode = SKSpriteNode(imageNamed: dish.imageNamed)
        dishImageNode.position = CGPoint(x: xPosition, y: yPosition)
        dishImageNode.size = CGSize(width: size / DexItemNode.IMAGE_RATIO, height: size / DexItemNode.IMAGE_RATIO)
        dishImageNode.zPosition = 2
        
        addChild(backgroundNode)
        addChild(dishImageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}