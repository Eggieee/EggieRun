//
//  Constructable.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/8/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

protocol Constructable {
    // Constructables should initialize themselves from a NSDictionary
    init(data: NSDictionary)
    
    var id: Int { get }
    
    // Constructables should return a weight in this method.
    // If returning 0, this constructable will never appear.
    // If returning a number less than 0, the constructable will always appear.
    //   - If more than one constructables are returning this, the one returning the least
    //     number will be constructed
    // If returning a number more than 0, the engine will use RNG to choose one.
    //   - The possibility of each constructable being selected is the weight returned.
    func canConstruct(resources: [Int: Int]) -> Int
}
