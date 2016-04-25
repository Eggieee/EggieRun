//
//  CollectableFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 28/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: CollectableFactory
// Description: a class computing next ingredients or condiments to generate
// based on certain formula and current distance of running.

import UIKit

class CollectableFactory {
    private static let MAX_NUM_OF_GAP: UInt32 = 5
    private static let UNIT_GAP_SIZE: CGFloat = 200
    private static let RATIO_INGREDIENT: UInt32 = 5
    private static let RATIO_CONDIMENT: UInt32 = 1
    
    func next(currentDistance: Int) -> Collectable {
        let random = arc4random_uniform(CollectableFactory.RATIO_INGREDIENT + CollectableFactory.RATIO_CONDIMENT)
        let numOfGap = CGFloat(arc4random_uniform(CollectableFactory.MAX_NUM_OF_GAP) + 1)
        let gapSize = numOfGap * CollectableFactory.UNIT_GAP_SIZE

        return random < CollectableFactory.RATIO_CONDIMENT ? Collectable(condimentType: Condiment.next(), gapSize: gapSize) : Collectable(ingredientType: Ingredient.next(currentDistance), gapSize: gapSize)
    }
}