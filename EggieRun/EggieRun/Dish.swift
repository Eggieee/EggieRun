//
//  Dish.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/21/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation
enum Dish: Int {
    case SmashedEgg = 0, OyakoDon = 1, SurstrommingEgg = 2, PlainBoiledEgg = -1, BlackFried = -2, BlackBaked = -3, BlackBoiled = -4
    
    static func getResultDish(cooker: Cooker, condiments: [Condiment], ingredients: [Ingredient]) -> Dish {
        
        if (cooker == .Drop) {
            return .SmashedEgg
        } else if (cooker == .DistanceForceDeath) {
            return .OyakoDon
        }
        
        // TODO: more dishes to come...
        
        if (cooker == .Pot && condiments.isEmpty) {
            return .PlainBoiledEgg
        } else if (cooker == .Pan) {
            return .BlackFried
        } else if (cooker == .Oven) {
            return .BlackBaked
        } else if (cooker == .Pot) {
            return .BlackBoiled
        }
        
        fatalError()
    }
}
