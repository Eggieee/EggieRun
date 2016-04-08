//
//  EndingLayer.swift
//  EggieRun
//
//  Created by  light on 2016/04/08.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class EndingLayer: SKSpriteNode {
    private var dish: Dish
    private var background: SKSpriteNode!
    
    init(generatedDish: Dish) {
        dish = generatedDish
        super.init(texture: nil, color: UIColor.clearColor(), size: UIScreen.mainScreen().bounds.size)
        fadeInBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fadeInBackground() {
        background = SKSpriteNode(imageNamed: "ending-background")
        background.alpha = 0
        addChild(background)
        let fadeInAction = SKAction.fadeInWithDuration(1.0)
        background.runAction(fadeInAction)
    }
}