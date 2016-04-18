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
    
    enum DistanceMode: Int {
        case Euclidean = 0, Ignore = 1, Same = 2
    }
    
    private static let PROB_PRECISION: Double = 20000
    
    let id: Int
    let name: String
    let description: String
    let hintDescription: String
    let titleImageNamed: String
    let rarity: Int
    let texture: SKTexture
//    let canConstructJsFunction: JSValue
    let standardWeight: Double
    let standardCondiments: [Condiment: Double]
    let requiredIngredients: Set<Ingredient>
    let requiredCooker: Cooker?
    let distanceMode: DistanceMode
    
    required init(data: NSDictionary) {
        self.id = data["id"] as! Int
        self.name = data["name"] as! String
        self.description = data["description"] as! String
        self.hintDescription = data["hintDescription"] as! String
        self.rarity = data["rarity"] as! Int
        
        let imageNamed = data["imageNamed"] as! String
        titleImageNamed = imageNamed + "-title"
        texture = SKTexture(imageNamed: imageNamed)
        
        self.standardWeight = data["standardWeight"] as! Double
        
        let standardCondimentsData = data["standardCondiments"] as! [Double]
        var standardCondiments = [Condiment: Double]()
        for condiment in Condiment.ALL_VALUES {
            standardCondiments[condiment] = standardCondimentsData[condiment.jsId]
        }
        self.standardCondiments = standardCondiments
        
        self.requiredIngredients = Set((data["requiredIngredients"] as! [Int]).map({ Ingredient(rawValue: $0)! }))
        self.requiredCooker = Cooker(rawValue: data["requiredCooker"] as! Int)
        self.distanceMode = DistanceMode(rawValue: data["distanceMode"] as! Int)!
        
//        let jsFunction = "var canConstruct = function(cooker, cond, ingred) { " + (data["canConstruct"] as! String) + " };"
//        let context = JSContext()
//        context.evaluateScript(jsFunction)
//        canConstructJsFunction = context.objectForKeyedSubscript("canConstruct")
        
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
        if self.requiredCooker != nil && cooker != self.requiredCooker {
            return 0
        }
        
        for ingredient in self.requiredIngredients {
            if !ingredients.contains(ingredient) {
                return 0
            }
        }
        
        var distanceSupplement: Double = 0
        let standardizedCondiments = Dish.standardizeCondiments(condiments)
        switch self.distanceMode {
        case .Ignore:
            distanceSupplement = Dish.distanceReduce(0)
            break
        case .Euclidean:
            distanceSupplement = Dish.distanceReduce(Dish.euclideanDistance(standardizedCondiments, withStandard: self.standardCondiments))
            break
        case .Same:
            if Dish.euclideanDistance(standardizedCondiments, withStandard: self.standardCondiments) == 0 {
                distanceSupplement = Dish.distanceReduce(0)
            } else {
                distanceSupplement = 0
            }
        }
        
        return Int(distanceSupplement * Dish.PROB_PRECISION * self.standardWeight)

//        var condimentsCount = [0, 0, 0]
//        var totalCondiments = 0
//        for condiment in condiments {
//            condimentsCount[condiment.0.jsId] = condiment.1
//            totalCondiments += condiment.1
//        }
//        
//        var jsCondiments: AnyObject?
//        if totalCondiments > 0 {
//            var condimentsRatio = [Double]()
//            for count in condimentsCount {
//                condimentsRatio.append(Double(count) / Double(totalCondiments))
//            }
//            jsCondiments = condimentsRatio
//        } else {
//            jsCondiments = [0, 0, 0]
//        }
//        
//        var jsIngredients = [String: Bool]()
//        for ingredient in ingredients {
//            jsIngredients[String(ingredient.rawValue)] = true
//        }
//        
//        return Int(canConstructJsFunction.callWithArguments([cooker.rawValue, jsCondiments!, jsIngredients]).toInt32())
    }
    
    static private func standardizeCondiments(data: [Condiment: Int]) -> [Condiment: Double] {
        var total = 0
        for condiment in Condiment.ALL_VALUES {
            total += data[condiment] ?? 0
        }
        if total == 0 {
            return [Condiment: Double]()
        } else {
            return data.map({ Double($0) / Double(total) })
        }
    }
    
    static private func euclideanDistance(data: [Condiment: Double], withStandard: [Condiment: Double]) -> Double {
        var distance: Double = 0
        
        for condiment in Condiment.ALL_VALUES {
            let difference = data[condiment] ?? 0 - withStandard[condiment]!
            distance += difference * difference
        }
        return sqrt(distance)
    }
    
    static private func distanceReduce(distance: Double) -> Double {
        return 1.0/(4.0 * distance + 1)
    }
}
