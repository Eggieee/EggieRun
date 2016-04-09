//
//  DexItemNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexItemNode: SKNode {
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
    
    init(dish: Dish, xPosition: CGFloat, yPosition: CGFloat, width: CGFloat, height: CGFloat) {
        self.dish = dish
        super.init()
        self.alpha = 0.5
        let dishImageNode = SKSpriteNode(imageNamed: dish.imageNamed)
        dishImageNode.position = CGPoint(x: xPosition, y: yPosition)
        dishImageNode.anchorPoint = CGPoint(x: 0, y: 0)
        dishImageNode.size = CGSize(width: width, height: height)
        addChild(dishImageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}