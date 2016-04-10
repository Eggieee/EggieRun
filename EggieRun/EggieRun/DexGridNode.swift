//
//  DexGridNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexGridNode: SKSpriteNode {
    static private let ITEMS_PER_ROW = 4
    static private let PADDING = CGFloat(20)
    static private let TITLE_SPACE = CGFloat(80)
    static private let GRID_RATIO = CGFloat(4.0 / 7)
    
    var width: CGFloat
    var height: CGFloat
    
    var dishNodes = [DexItemNode]()
    
    init(sceneHeight: CGFloat, sceneWidth: CGFloat){
        width = DexGridNode.GRID_RATIO * sceneWidth
        height = sceneHeight - DexGridNode.TITLE_SPACE
        
        
        super.init(texture: SKTexture(imageNamed: "grid-texture"), color: UIColor.grayColor(), size: CGSize(width: width, height: height))
        self.position = CGPoint(x: 0, y: 0)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        let itemSize = (width - DexGridNode.PADDING * CGFloat(DexGridNode.ITEMS_PER_ROW + 1)) / CGFloat(DexGridNode.ITEMS_PER_ROW)
        
        for i in 0..<DishDataController.singleton.dishes.count {
            let row = i / DexGridNode.ITEMS_PER_ROW
            let col = i % DexGridNode.ITEMS_PER_ROW
            
            let x = CGFloat(col + 1) * DexGridNode.PADDING + (CGFloat(col) + 0.5) * itemSize
            let y = height - (CGFloat(row + 1) * DexGridNode.PADDING + (CGFloat(row) + 0.5) * itemSize) 
            
            let item = DexItemNode(dish: DishDataController.singleton.dishes[i], xPosition: x, yPosition: y, size: itemSize)
            
            addChild(item)
            dishNodes.append(item)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
