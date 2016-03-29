//
//  Condiment.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/22/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation
enum Condiment: Int {
    case Salt = 0, Sugar = 1, Chili = 2
    
    static let randomPool = RandomPool<Condiment>(objects: [.Salt, .Sugar, .Chili])
    
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
}
