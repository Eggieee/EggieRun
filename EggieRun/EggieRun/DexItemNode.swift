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
    
    static private let UNACTIVATED_FILTER = CIFilter(name: "CIColorClamp", withInputParameters: ["inputMaxComponents": CIVector(string: "[0 0 0 1]")])
    
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
    private(set) var activated = true
    
    init(dish: Dish, xPosition: CGFloat, yPosition: CGFloat, size: CGFloat) {
        self.dish = dish
        super.init()
        self.alpha = DexItemNode.UNSELECTED_ALPHA
        
        // background node of dishes
        let backgroundNode = SKSpriteNode(imageNamed: "item-background")
        backgroundNode.position = CGPoint(x: xPosition, y: yPosition)
        backgroundNode.size = CGSize(width: size, height: size)
        backgroundNode.zPosition = DexItemNode.BACKGROUND_Z
        
        // initial effect before the dish is activated in game
        let effectNode = SKEffectNode()
        effectNode.zPosition = DexItemNode.DISH_Z
        if !DishDataController.singleton.isDishActivated(dish) {
            effectNode.filter = DexItemNode.UNACTIVATED_FILTER
            activated = false
        }
        
        // add dish image node
        let dishImageNode = SKSpriteNode(imageNamed: dish.imageNamed)
        dishImageNode.position = CGPoint(x: xPosition, y: yPosition)
        dishImageNode.size = CGSize(width: size / DexItemNode.IMAGE_RATIO, height: size / DexItemNode.IMAGE_RATIO)
        effectNode.addChild(dishImageNode)
        
        addChild(backgroundNode)
        addChild(effectNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
