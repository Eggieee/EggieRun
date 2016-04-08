//
//  Condiment.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation
enum Condiment: Int {
    case Salt = 10, Sugar = 11, Chili = 12
    
    static let randomPool = RandomPool<Condiment>(objects: [.Salt, .Sugar, .Chili], weightages: [5, 4, 1])
    
    static func next() -> Condiment {
        return randomPool.draw()
    }
    
    var imageNamed: String {
        switch self {
        case .Salt:
            return "salt"
        case .Sugar:
            return "sugar"
        case .Chili:
            return "chili"
        }
    }
    
    var jsId: Int {
        return self.rawValue - 10
    }
}
