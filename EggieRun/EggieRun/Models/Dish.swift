//
//  Dish.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/21/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import JavaScriptCore

class Dish: Constructable {
    let id: Int
    let name: String
    let description: String
    let imageNamed: String
    let canConstructRawFunction: String
    
    required init(data: NSDictionary) {
        self.id = data["id"] as! Int
        self.name = data["name"] as! String
        self.description = data["description"] as! String
        self.imageNamed = data["imageNamed"] as! String
        self.canConstructRawFunction = "var canConstruct = function(cooker, condiments, ingredients) { " + (data["canConstruct"] as! String) + " };"
    }
    
    func canConstruct(resources: [Int : Int]) -> Int {
        var cooker: Cooker?
        var condiments = [Condiment: Int]()
        var ingredients = [Ingredient]()
        
        for item in resources {
            let resourceId = item.0
            let resourceCount = item.1
            if let isCooker = Cooker(rawValue: resourceId) {
                if cooker == nil {
                    cooker = isCooker
                } else {
                    fatalError()
                }
            } else if let isCondiment = Condiment(rawValue: resourceId) {
                condiments[isCondiment] = resourceCount
            } else if let isIngredient = Ingredient(rawValue: resourceId) {
                for _ in 0..<resourceCount {
                    ingredients.append(isIngredient)
                }
            }
        }
        
        return canConstruct(cooker!, condiments: condiments, ingredients: ingredients)
    }
    
    // <0: force appear, the less the number the higher the priority
    // =0: cannot appear
    // >0: randomly appear, the larger the number the higher the probability
    // func sign in js: function(int cooker, [int] condiments, [int] ingredients) -> int
    func canConstruct(cooker: Cooker, condiments: [Condiment: Int], ingredients: [Ingredient]) -> Int {
        let context = JSContext()
        context.evaluateScript(self.canConstructRawFunction)
        let jsFunction = context.objectForKeyedSubscript("canConstruct")
        
        var jsCondiments = [0, 0, 0]
        for condiment in condiments {
            jsCondiments[condiment.0.jsId] = condiment.1
        }
        
        return Int(jsFunction.callWithArguments([cooker.rawValue, jsCondiments, ingredients.map({$0.rawValue})]).toInt32())
    }
}
