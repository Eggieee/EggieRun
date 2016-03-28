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
    
    var next: Condiment {
        return .Salt
    }
    
    var imageNamed: String {
        switch self {
        default:
            return "tomato"
        }
    }
}
