//
//  IngredientBar.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class IngredientBar: SKSpriteNode {
    private static let X_DISTANCE = CGFloat(100)
    private static let MAX_GRID_NUMBER = 5
    
    var ingredients = [Ingredient]()
    var ingredientGrids = [IngredientGrid]()
    var firstEmptyIndex: Int {
        get {
            if (ingredients.count < IngredientBar.MAX_GRID_NUMBER) {
                return ingredients.count
            } else {
                return IngredientBar.MAX_GRID_NUMBER - 1
            }
        }
    }
    var isFull: Bool {
        get {
            return (ingredients.count >= IngredientBar.MAX_GRID_NUMBER)
        }
    }
    
    init() {
        let barSize = CGSizeMake(500, 90)
        super.init(texture: nil, color: UIColor.clearColor(), size: barSize)
    }
    
    // todo
    func addIngredient(newIngredient: Ingredient) {
        let newGrid = IngredientGrid(ingredientType: newIngredient)
        updateBarLayout(newGrid)
        updateArray(newIngredient, newGrid: newGrid)
    }
    
    // new grid is added into array alr
    func updateBarLayout(newGrid: IngredientGrid) {
        if (isFull) {
            animateMovingGridByOne()
        }
        animateAddingNewGrid(newGrid)
    }
    
    func animateMovingGridByOne() {
        for i in 0..<ingredients.count {
            let grid = ingredientGrids[i]
            // moving animation goes here
            grid.position.x -= IngredientBar.X_DISTANCE
            
            if (i==0) {
                grid.removeFromParent()
            }
        }
    }
    
    func animateAddingNewGrid(newGrid: IngredientGrid) {
        let position = CGPointMake(CGFloat(firstEmptyIndex) * IngredientBar.X_DISTANCE, 0)
        newGrid.position = position
        addChild(newGrid)
    }
    
    func updateArray(newIngredient: Ingredient, newGrid: IngredientGrid) {
        if (isFull) {
            print("is full!")
            moveGridByOne()
        }
        print(firstEmptyIndex)
        ingredients.append(newIngredient)
        ingredientGrids.append(newGrid)
    }
    
    func moveGridByOne() {
        for i in 0..<IngredientBar.MAX_GRID_NUMBER-1 {
            ingredients[i] = ingredients[i+1]
            ingredientGrids[i] = ingredientGrids[i+1]
        }
        ingredients.removeLast()
        ingredientGrids.removeLast()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}