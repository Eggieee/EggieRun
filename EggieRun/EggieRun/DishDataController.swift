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
    
    private(set) var dishes = [Int:Dish]()
    
    init() {
        if let url = NSBundle.mainBundle().URLForResource("Dishes", withExtension: "plist") {
            let data = NSArray(contentsOfURL: url)!
            for element in data {
                let dishData = element as! NSDictionary
                let dish = Dish(data: dishData)
                dishes[dish.id.rawValue] = dish
            }
        } else {
            fatalError()
        }
    }
    
    func getDish(id: Dish.DishId) -> Dish? {
        return dishes[id.rawValue]
    }
    
    func getResultDish(cooker: Cooker, condiments: [Condiment], ingredients: [Ingredient]) -> Dish {
        let randomPool = RandomPool<Dish>()
        
        var forceAppearDishPriority = 0
        var forceAppearDish: Dish?
        
        for element in dishes {
            let thisDishCanConstruct = element.1.canConstruct(cooker, condiments: condiments, ingredients: ingredients)
            
            if thisDishCanConstruct < forceAppearDishPriority {
                forceAppearDishPriority = thisDishCanConstruct
                forceAppearDish = element.1
            } else if thisDishCanConstruct > 0 {
                randomPool.addObject(element.1, weightage: thisDishCanConstruct)
            }
        }
        
        if forceAppearDish != nil {
            return forceAppearDish!
        } else {
            return randomPool.draw()
        }
    }
}
