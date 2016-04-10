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
    static private let BACKGROUND_Z = CGFloat(1)
    static private let DISH_Z = CGFloat(2)
    static private let UNSELECTED_ALPHA = CGFloat(0.5)
    static private let SELECTED_ALPHA = CGFloat(1.0)
    
    let dish: Dish
    var selected = false {
        didSet {
            if selected {
                self.alpha = DexItemNode.SELECTED_ALPHA
            } else {
                self.alpha = DexItemNode.UNSELECTED_ALPHA
            }
        }
    }
    
    init(dish: Dish, xPosition: CGFloat, yPosition: CGFloat, size: CGFloat) {
        self.dish = dish
        super.init()
        self.alpha = DexItemNode.UNSELECTED_ALPHA
        
        let backgroundNode = SKSpriteNode(imageNamed: "item-background")
        backgroundNode.position = CGPoint(x: xPosition, y: yPosition)
        backgroundNode.size = CGSize(width: size, height: size)
        backgroundNode.zPosition = DexItemNode.BACKGROUND_Z
        
        let dishImageNode = SKSpriteNode(imageNamed: dish.imageNamed)
        dishImageNode.position = CGPoint(x: xPosition, y: yPosition)
        dishImageNode.size = CGSize(width: size / DexItemNode.IMAGE_RATIO, height: size / DexItemNode.IMAGE_RATIO)
        dishImageNode.zPosition = DexItemNode.DISH_Z
        
        addChild(backgroundNode)
        addChild(dishImageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}