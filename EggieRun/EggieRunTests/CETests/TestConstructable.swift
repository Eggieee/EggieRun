//
//  TestConstructable.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/20/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation
@testable import EggieRun

class TestConstructable: Constructable {
    var id: Int
    
    required init(data: NSDictionary) {
        id = data["id"] as! Int
    }
    
    func canConstruct(resources: [Int : Int]) -> Int {
        switch id {
        case 0:
            return 0
        case 1:
            if resources.isEmpty {
                return 0
            } else {
                return -1
            }
        case 2:
            return 1
        case 3:
            return 1
        default:
            fatalError()
        }
    }
}
