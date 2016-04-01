//
//  Dish.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/21/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import JavaScriptCore

class Dish {
    let id: Int
    let name: String
    let description: String
    let imageNamed: String
    let canConstructRawFunction: String
    
    init(data: NSDictionary) {
        self.id = data["id"] as! Int
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
