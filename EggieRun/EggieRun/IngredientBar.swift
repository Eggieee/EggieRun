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
    private static let IS_NOT_CONTAINED_INDEX = -1
    
    var ingredients = [Ingredient]()
    private var ingredientGrids = [IngredientGrid]()
    private var emptyGrids = [IngredientGrid]()
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
        initializeEmptyGrids()
    }
    
    func initializeEmptyGrids() {
        for i in 0..<IngredientBar.MAX_GRID_NUMBER {
            let newEmptyGrid = IngredientGrid(ingredientType: nil)
            let position = CGPointMake(CGFloat(i) * IngredientBar.X_DISTANCE, 0)
            newEmptyGrid.position = position
            addChild(newEmptyGrid)
            emptyGrids.append(newEmptyGrid)
        }
    }
    
    func addIngredient(newIngredient: Ingredient) {
        let newGrid = IngredientGrid(ingredientType: newIngredient)
        var index = IngredientBar.IS_NOT_CONTAINED_INDEX
        let isDuplicate = ingredients.contains(newIngredient)
        
        if (isDuplicate) {
            index = ingredients.indexOf(newIngredient)!
        } else if (!isFull) {
            updateEmptyGrids()
        }
        
        updateBarLayout(newGrid, index: index)
        updateArray(newIngredient, newGrid: newGrid, index: index)
    }
    
    func updateEmptyGrids() {
        emptyGrids[0].removeFromParent()
        emptyGrids.removeFirst()
    }
    
    /*
    func getNextGridPosition() -> CGPoint {
        let nextX = CGFloat(firstEmptyIndex) * IngredientBar.X_DISTANCE
        return CGPointMake(nextX, <#T##y: CGFloat##CGFloat#>)
    }
*/
    
    func updateBarLayout(newGrid: IngredientGrid, index: Int) {
        let isDuplicate = (index != IngredientBar.IS_NOT_CONTAINED_INDEX)
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
                let movingAction = SKAction.moveByX(-IngredientBar.X_DISTANCE, y: 0, duration: 0.5)
                //grid.position.x -= IngredientBar.X_DISTANCE
                grid.runAction(movingAction)
            }
        }
    }
    
    func animateAddingNewGrid(newGrid: IngredientGrid, isDuplicate: Bool) {
        let nextIndex = (isFull || isDuplicate) ? firstEmptyIndex-1 : firstEmptyIndex
        let position = CGPointMake(CGFloat(nextIndex) * IngredientBar.X_DISTANCE, 0)
        newGrid.position = position
        addChild(newGrid)
    }
    
    func animateMovingIngredient(ingredient: Ingredient,originalPosition: CGPoint, newPosition: CGPoint) {
        
    }
    
    func updateArray(newIngredient: Ingredient, newGrid: IngredientGrid, index: Int) {
        if (index != IngredientBar.IS_NOT_CONTAINED_INDEX) {
            moveGridByOne(index)
        } else if (isFull) {
            moveGridByOne(0)
        }
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