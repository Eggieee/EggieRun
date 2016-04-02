//
//  IngredientGrid.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class IngredientGrid: SKSpriteNode {
    private static let GRIDSIZE = CGSizeMake(90, 90)
    private static let IMGSIZE = CGSizeMake(75, 75)
    private static let GRID_IMG_NAME = "ingredient-grid"
    
    let ingredient: Ingredient?
    var ingredientNode: SKSpriteNode? = nil
    //let texture = SKTexture(imageNamed: ingredient!.flatImageNamed)
    
    init(ingredientType: Ingredient) {
        ingredient = ingredientType
        let texture = SKTexture(imageNamed: IngredientGrid.GRID_IMG_NAME)
        super.init(texture: texture, color: UIColor.clearColor(), size: IngredientGrid.GRIDSIZE)
        initializeIngredientNode()
    }
    
    private func initializeIngredientNode() {
        let texture = SKTexture(imageNamed: ingredient!.flatImageNamed)
        ingredientNode = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: IngredientGrid.IMGSIZE)
        ingredientNode!.position = CGPointMake(0, 0)
        ingredientNode!.zPosition = zPosition + 1
        addChild(ingredientNode!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}