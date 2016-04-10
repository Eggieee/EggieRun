//
//  Dish.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/21/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import JavaScriptCore
import SpriteKit

class Dish: Constructable {
    let id: Int
    let name: String
    let description: String
    let titleImageNamed: String
    let rarity: Int
    let texture: SKTexture
    let canConstructJsFunction: JSValue
    
    required init(data: NSDictionary) {
        self.id = data["id"] as! Int
        self.name = data["name"] as! String
        self.description = data["description"] as! String
        self.rarity = data["rarity"] as! Int
        
        let imageNamed = data["imageNamed"] as! String
        titleImageNamed = imageNamed + "-title"
        texture = SKTexture(imageNamed: imageNamed)
        
        let jsFunction = "var canConstruct = function(cooker, cond, ingred) { " + (data["canConstruct"] as! String) + " };"
        let context = JSContext()
        context.evaluateScript(jsFunction)
        canConstructJsFunction = context.objectForKeyedSubscript("canConstruct")
    }
    
    func canConstruct(resources: [Int: Int]) -> Int {
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
                for _ in 0 ..< resourceCount {
                    ingredients.append(isIngredient)
                }
            }
        }
        
        return canConstruct(cooker!, condiments: condiments, ingredients: ingredients)
    }
    
    // <0: force appear, the less the number the higher the priority
    // =0: cannot appear
    // >0: randomly appear, the larger the number the higher the probability
    // func sign in js: function(int cooker, [double] cond, [func] ingred) -> int
    func canConstruct(cooker: Cooker, condiments: [Condiment: Int], ingredients: [Ingredient]) -> Int {
        var condimentsCount = [0, 0, 0]
        var totalCondiments = 0
        for condiment in condiments {
            condimentsCount[condiment.0.jsId] = condiment.1
            totalCondiments += condiment.1
        }
        
        var jsCondiments: AnyObject?
        if totalCondiments > 0 {
            var condimentsRatio = [Double]()
            for count in condimentsCount {
                condimentsRatio.append(Double(count) / Double(totalCondiments))
            }
            jsCondiments = condimentsRatio
        } else {
            jsCondiments = [0, 0, 0]
        }
        
        var jsIngredients = [Int: Bool]()
        for ingredient in ingredients {
            jsIngredients[ingredient.rawValue] = true
        }
        
        return Int(canConstructJsFunction.callWithArguments([cooker.rawValue, jsCondiments!, jsIngredients]).toInt32())
    }
}
