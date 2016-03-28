//
//  Ingredient.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation
enum Ingredient: Int {
    case GreenOnion = 0, Tomato = 1, Cream = 2, Milk = 3, Rice = 4, Bread = 5, Bacon = 6, Strawberry = 7, Chocolate = 8, Surstromming = -1
    
    static func next(distance: Int) -> Ingredient {
        let randomPool = RandomPool<Ingredient>(objects: [.GreenOnion, .Tomato, .Cream, .Milk, .Rice, .Bread, .Bacon, .Strawberry, .Chocolate])
        return randomPool.draw()
    }
    
    private var imageNamed: String {
        switch self {
        case .GreenOnion:
            return "green-onion"
        case .Tomato:
            return "tomato"
        case .Cream:
            return "cream"
        case .Milk:
            return "milk"
        case .Rice:
            return "rice"
        case .Bread:
            return "bread"
        case .Bacon:
            return "bacon"
        case .Strawberry:
            return "strawberry"
        case .Chocolate:
            return "chocolate"
        case .Surstromming:
            return ""
        }
    }
    
    var flatImageNamed: String {
        return "flat-" + imageNamed
    }
    
    var fineImageNamed: String {
        return "fine-" + imageNamed
    }
}
