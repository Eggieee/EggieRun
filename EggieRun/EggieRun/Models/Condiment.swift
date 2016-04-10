//
//  Condiment.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

enum Condiment: Int {
    case Salt = 10, Sugar = 11, Chili = 12
    
    static let ALL_VALUES: [Condiment] = [.Salt, .Sugar, .Chili]
    
    static private let TEXTURES: [Condiment: SKTexture] = Dictionary(ALL_VALUES.map({ ($0, SKTexture(imageNamed: $0.imageNamed)) }))
    
    static let randomPool = RandomPool<Condiment>(objects: [.Salt, .Sugar, .Chili], weightages: [5, 4, 1])
    
    static func next() -> Condiment {
        return randomPool.draw()
    }
    
    private var imageNamed: String {
        switch self {
        case .Salt:
            return "salt"
        case .Sugar:
            return "sugar"
        case .Chili:
            return "chili"
        }
    }
    
    var texture: SKTexture {
        return Condiment.TEXTURES[self]!
    }
    
    var jsId: Int {
        return self.rawValue - 10
    }
}
