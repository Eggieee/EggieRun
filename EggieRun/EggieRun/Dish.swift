//
//  Dish.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/21/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import JavaScriptCore

class Dish {
    enum DishId: Int {
        case SmashedEgg = 0, OyakoDon = 1, SurstrommingEgg = 2, PlainBoiledEgg = -1, BlackFried = -2, BlackBaked = -3, BlackBoiled = -4
    }
    
    let id: DishId
    let name: String
    let description: String
    let imageNamed: String
    let canConstructRawFunction: String
    
    init(data: NSDictionary) {
        self.id = DishId(rawValue: data["id"] as! Int)!
        self.name = data["name"] as! String
        self.description = data["description"] as! String
        self.imageNamed = data["imageNamed"] as! String
        self.canConstructRawFunction = "var canConstruct = function(cooker, condiments, ingredients) { " + (data["canConstruct"] as! String) + " };"
    }
    
    
    // <0: force appear, the less the number the higher the priority
    // =0: cannot appear
    // >0: randomly appear, the larger the number the higher the probability
    // func sign in js: function(int cooker, [int] condiments, [int] ingredients) -> int
    func canConstruct(cooker: Cooker, condiments: [Condiment], ingredients: [Ingredient]) -> Int {
        let context = JSContext()
        context.evaluateScript(self.canConstructRawFunction)
        let jsFunction = context.objectForKeyedSubscript("canConstruct")
        
        var condimentsForJs = [0, 0, 0]
        for condiment in condiments {
            condimentsForJs[condiment.rawValue] += 1
        }
        
        return Int(jsFunction.callWithArguments([cooker.rawValue, condimentsForJs, ingredients.map({$0.rawValue})]).toInt32())
    }
}


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
        var randomPool = [Dish]()
        
        var forceAppearDishPriority = 0
        var forceAppearDish: Dish?
        
        for element in dishes {
            let thisDishCanConstruct = element.1.canConstruct(cooker, condiments: condiments, ingredients: ingredients)
            
            if thisDishCanConstruct < forceAppearDishPriority {
                forceAppearDishPriority = thisDishCanConstruct
                forceAppearDish = element.1
            } else if thisDishCanConstruct > 0 {
                for _ in 0..<thisDishCanConstruct {
                    randomPool.append(element.1)
                }
            }
        }
        
        if forceAppearDish != nil {
            return forceAppearDish!
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(randomPool.count)))
            return randomPool[randomIndex]
        }
    }
    
    private func getResultDishId(cooker: Cooker, condiments: [Condiment], ingredients: [Ingredient]) -> Dish.DishId {
        
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
