//
//  Ingredient.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

enum Ingredient: Int {
    private static let DISTANCES_TURNING_POINT = [Milestone.PresentShelf, Milestone.ChallengeDarkness].map({ $0.rawValue })
    
    case GreenOnion = 100, Tomato = 101, Cream = 102, Milk = 103, Rice = 104, Bread = 105, Bacon = 106, Strawberry = 107, Chocolate = 108, Surstromming = 109
    
    static let ALL_VALUES: [Ingredient] = [.GreenOnion, .Tomato, .Cream, .Milk, .Rice, .Bread, .Bacon, .Strawberry, .Chocolate, .Surstromming]
    
    static private let FLAT_TEXTURES: [Ingredient: SKTexture] = Dictionary(ALL_VALUES.map({ ($0, SKTexture(imageNamed: $0.flatImageNamed)) }))
    static private let FINE_TEXTURES: [Ingredient: SKTexture] = Dictionary(ALL_VALUES.map({ ($0, SKTexture(imageNamed: $0.fineImageNamed)) }))
    
    static let rarityTable: [[Ingredient]] = [[.Milk], [.GreenOnion, .Tomato, .Cream, .Rice, .Bacon, .Strawberry], [.Bread, .Chocolate], [.Surstromming]]
    
    static let rarityPools = rarityTable.map({ RandomPool(objects: $0) })
    
    static func next(distance: Int) -> Ingredient {
        let randomPool: RandomPool<RandomPool<Ingredient>>!
        if distance < Ingredient.DISTANCES_TURNING_POINT[0] {
            randomPool = RandomPool(objects: [rarityPools[0], rarityPools[1]], weightages: [3, 10])
        } else if distance < Ingredient.DISTANCES_TURNING_POINT[1] {
            randomPool = RandomPool(objects: [rarityPools[0], rarityPools[1], rarityPools[2]], weightages: [3, 10, 2])
        } else {
            randomPool = RandomPool(objects: rarityPools, weightages: [60, 200, 40, 1])
        }
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
            return "surstromming"
        }
    }
    
    private var flatImageNamed: String {
        return "flat-" + imageNamed
    }
    
    private var fineImageNamed: String {
        return "fine-" + imageNamed
    }
    
    var flatTexture: SKTexture {
        return Ingredient.FLAT_TEXTURES[self]!
    }
    
    var fineTexture: SKTexture {
        return Ingredient.FINE_TEXTURES[self]!
    }
}
