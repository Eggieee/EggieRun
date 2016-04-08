//
//  DexItemNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexItemNode: SKNode {
    
    init(item: Dish, xPosition: CGFloat, yPosition: CGFloat, width:CGFloat, height:CGFloat){
        super.init()
        self.alpha = 0.5
        let item = SKSpriteNode(imageNamed: item.imageNamed)
        item.position = CGPoint(x: xPosition,y: yPosition)
        item.anchorPoint = CGPoint(x: 0,y: 0)
        item.size = CGSize(width:width, height:height)
        addChild(item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}