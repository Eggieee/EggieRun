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
    
    static private let UNACTIVATED_FILTER = CIFilter(name: "CIColorControls", withInputParameters: ["inputBrightness": -1])
    
    let dish: Dish
    private(set) var activated = true
    
    private static func ITEM_BACKGROUND_IMAGENAMED(rarity: Int) -> String {
        return "item-background-" + String(rarity)
    }
    
    init(dish: Dish, xPosition: CGFloat, yPosition: CGFloat, size: CGFloat) {
        self.dish = dish
        super.init()
        self.position = CGPoint(x: xPosition, y: yPosition)
        
        // background node of dishes
        let backgroundNode = SKSpriteNode(imageNamed: DexItemNode.ITEM_BACKGROUND_IMAGENAMED(dish.rarity))
        backgroundNode.size = CGSize(width: size, height: size)
        backgroundNode.zPosition = DexItemNode.BACKGROUND_Z
        
        // initial effect before the dish is activated in game
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.zPosition = DexItemNode.DISH_Z
        if !DishDataController.singleton.isDishActivated(dish) {
            effectNode.filter = DexItemNode.UNACTIVATED_FILTER
            activated = false
        }
        
        // add dish image node
        let dishImageNode = SKSpriteNode(texture: dish.texture)
        dishImageNode.size = CGSize(width: size / DexItemNode.IMAGE_RATIO, height: size / DexItemNode.IMAGE_RATIO)
        effectNode.addChild(dishImageNode)
        
        addChild(backgroundNode)
        addChild(effectNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
