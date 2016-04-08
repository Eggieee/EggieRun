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
    private var ingredientGrids = [IngredientGrid]()
    var firstEmptyIndex: Int {
        get {
            return ingredients.count
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
    
    func addIngredient(newIngredient: Ingredient) {
        let newGrid = IngredientGrid(ingredientType: newIngredient)
        var index = -1
        
        if (ingredients.contains(newIngredient)) {
            index = ingredients.indexOf(newIngredient)!
        }
        
        updateBarLayout(newGrid, index: index)
        updateArray(newIngredient, newGrid: newGrid, index: index)
    }
    
    func updateBarLayout(newGrid: IngredientGrid, index: Int) {
        let isDuplicate = (index != -1)
        if (isDuplicate) {
            animateMovingGridByOne(index)
        } else if (isFull) {
            animateMovingGridByOne(0)
        }
        animateAddingNewGrid(newGrid, isDuplicate: isDuplicate)
    }
    
    func animateMovingGridByOne(startIndex: Int) {
        for i in startIndex..<ingredients.count {
            let grid = ingredientGrids[i]
            // moving animation goes here
            if (i==startIndex) {
                grid.removeFromParent()
            } else {
                grid.position.x -= IngredientBar.X_DISTANCE
            }
        }
    }
    
    func animateAddingNewGrid(newGrid: IngredientGrid, isDuplicate: Bool) {
        let nextIndex = (isFull || isDuplicate) ? firstEmptyIndex-1 : firstEmptyIndex
        let position = CGPointMake(CGFloat(nextIndex) * IngredientBar.X_DISTANCE, 0)
        newGrid.position = position
        addChild(newGrid)
    }
    
    func updateArray(newIngredient: Ingredient, newGrid: IngredientGrid, index: Int) {
        if (index != -1) {
            moveGridByOne(index)
        } else if (isFull) {
            moveGridByOne(0)
        }
        print(firstEmptyIndex)
        ingredients.append(newIngredient)
        ingredientGrids.append(newGrid)
    }
    
    func moveGridByOne(startIndex: Int) {
        ingredients.removeAtIndex(startIndex)
        ingredientGrids.removeAtIndex(startIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}