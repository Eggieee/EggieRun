//
//  IngredientBar.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class IngredientBar: SKSpriteNode {
    var ingredients = [Ingredient]()
    var ingredientGrids = [IngredientGrid]()
    
    init(position: CGPoint) {
        let barSize = CGSizeMake(500, 90)
        super.init(texture: nil, color: UIColor.clearColor(), size: barSize)
    }
    
    // todo
    func addIngredient(newIngredient: Ingredient) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}