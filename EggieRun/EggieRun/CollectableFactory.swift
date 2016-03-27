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
        
        return Collectable(colletableType: .Ingredient, collectableRawValue: 0, gapSize: gapSize)
    }
}