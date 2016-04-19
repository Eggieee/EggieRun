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
    
    private static let STORAGE_FILE_NAME = "eggdex.data"
    private static let STORAGE_KEY = "eggdex"
    
    var dishes: [Dish] {
        return constructableEngine.constructables
    }
    var activatedDishes: [Dish] {
        return constructableEngine.activatedConstructables
    }
    
    init() {
        if let url = NSBundle.mainBundle().URLForResource("Dishes", withExtension: "plist") {
            constructableEngine = ConstructableEngine<Dish>(dataUrl: url, storageFileName: DishDataController.STORAGE_FILE_NAME)
        } else {
            fatalError()
        }
    }
    
    func getResultDish(cooker: Cooker, condiments: [Condiment: Int], ingredients: [Ingredient]) -> (Dish, Bool) {
        var resources = [Int: Int]()
        
        resources[cooker.rawValue] = 1
        
        for condiment in condiments {
            resources[condiment.0.rawValue] = condiment.1
        }
        
        for ingredient in ingredients {
            resources[ingredient.rawValue] = (resources[ingredient.rawValue] ?? 0) + 1
        }
        
        let result = constructableEngine.getConstructResult(resources)
        NSLog("Constructed dish %@", result.0.name)
        return result
    }
    
    func isDishActivated(dish: Dish) -> Bool {
        return constructableEngine.isConstructableActivated(dish)
    }
    
    func isDishNew(dish: Dish) -> Bool {
        return constructableEngine.isConstructableNew(dish)
    }
    
    func clearActivatedDishes() -> Bool {
        return constructableEngine.clearActivated()
    }
    
    func clearNewFlags() -> Bool {
        return constructableEngine.clearNewFlags()
    }
    
    func forceActivateAllDishes() {
        for dish in dishes {
            constructableEngine.forceActivateConstructable(dish)
        }
    }
}
