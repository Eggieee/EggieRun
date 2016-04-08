//
//  Ingredient.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation
enum Ingredient: Int {
    case GreenOnion = 100, Tomato = 101, Cream = 102, Milk = 103, Rice = 104, Bread = 105, Bacon = 106, Strawberry = 107, Chocolate = 108, Surstromming = 109
    
    static let rarityTable: [[Ingredient]] = [[.Milk], [.GreenOnion, .Tomato, .Cream, .Rice, .Bacon, .Strawberry], [.Bread, .Chocolate], [.Surstromming]]
    
    static let rarityPools = rarityTable.map({RandomPool(objects: $0)})
    
    static func next(distance: Int) -> Ingredient {
        let randomPool = RandomPool(objects: rarityPools, weightages: [30, 100, 20, 1])
        return randomPool.draw().draw()
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
