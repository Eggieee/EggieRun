//
//  DishDataController.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/28/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// This class will be refactored to be a standalone component

import Foundation

class DishDataController {
    static let singleton = DishDataController()
    
    private let constructableEngine: ConstructableEngine<Dish>
    
    var dishes: [Dish] {
        return constructableEngine.constructables
    }
    
    init() {
        if let url = NSBundle.mainBundle().URLForResource("Dishes", withExtension: "plist") {
            constructableEngine = ConstructableEngine<Dish>(url: url)
        } else {
            fatalError()
        }
    }
    
    func getResultDish(cooker: Cooker, condiments: [Condiment: Int], ingredients: [Ingredient]) -> Dish {
        var resources = [Int: Int]()
        
        resources[cooker.rawValue] = 1
        
        for condiment in condiments {
            resources[condiment.0.rawValue] = condiment.1
        }
        
        for ingredient in ingredients {
            resources[ingredient.rawValue] = (resources[ingredient.rawValue] ?? 0) + 1
        }
        
        return constructableEngine.getConstructResult(resources)
    }
}
