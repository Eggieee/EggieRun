//
//  DexGridNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexGridNode: SKSpriteNode {
    var width: CGFloat
    var height: CGFloat
    
    var dishNodes = [DexItemNode]()
    
    init(sceneHeight:CGFloat, sceneWidth:CGFloat){
        width = 4*sceneWidth/7
        height = sceneHeight - 80
        super.init(texture: nil, color: UIColor.grayColor(), size: CGSize(width: width, height:height))
        self.position = CGPoint(x: 0,y: 0)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        for i in 0..<DishDataController.singleton.dishes.count {
            let x = width/4*CGFloat((i)%4) + 20
            let y = 4*height/5-height/5*CGFloat((i)/4)
            let item = DexItemNode(dish: DishDataController.singleton.dishes[i], xPosition: x, yPosition: y, width:width/6, height: width/6)
            item.zPosition = 1
            addChild(item)
            dishNodes.append(item)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
