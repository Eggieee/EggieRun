//
//  DexDetailNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexDetailNode: SKSpriteNode {
    
    init(dish:Dish, sceneHeight: CGFloat, sceneWidth:CGFloat) {
        super.init(texture: nil, color: UIColor.brownColor(), size: CGSize(width: 3*sceneWidth/7, height: sceneHeight-80))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x:4*sceneWidth/7, y:0)
        
        // add content of dish
        let image = SKSpriteNode(imageNamed: dish.imageNamed)
        let text = SKLabelNode(text: dish.description)
        image.anchorPoint=CGPoint(x: 0, y: 0)
        image.position = CGPoint(x: 30,y: 1*sceneHeight/3)
        text.position = CGPoint(x: self.frame.width/2,y: sceneHeight/4)
        addChild(image)
        addChild(text)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
