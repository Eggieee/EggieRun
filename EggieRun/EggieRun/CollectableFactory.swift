//
//  CollectableFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 28/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit

class CollectableFactory {
    func nextColletable() -> Collectable {
        let gapSize: CGFloat = 400
        let random = arc4random() % 6

        return random == 0 ? Collectable(condimentType: Condiment.next(), gapSize: gapSize) : Collectable(ingredientType: Ingredient.next(100), gapSize: gapSize)
    }
}