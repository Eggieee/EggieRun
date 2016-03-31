//
//  IngredientBar.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class IngredientBar: SKSpriteNode {
    init(position: CGPoint) {
        let barSize = CGSize(width: 500, height: 90)
        super.init(texture: nil, color: UIColor.clearColor(), size: barSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}