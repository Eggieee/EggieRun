//
//  CollectableFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 28/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit

class CollectableFactory {
    private static let MAX_NUM_OF_MID_PIECE: UInt32 = 2
    private static let MAX_NUM_OF_GAP: UInt32 = 5
    private static let UNIT_GAP_SIZE: CGFloat = 200
    
    func nextColletable() -> Collectable {
        let random = arc4random() % 6
        let numOfGap = CGFloat(arc4random() % CollectableFactory.MAX_NUM_OF_GAP + 1)
        let gapSize = numOfGap * CollectableFactory.UNIT_GAP_SIZE

        return random == 0 ? Collectable(condimentType: Condiment.next(), gapSize: gapSize) : Collectable(ingredientType: Ingredient.next(100), gapSize: gapSize)
    }
}