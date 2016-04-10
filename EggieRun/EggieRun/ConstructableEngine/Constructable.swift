//
//  Constructable.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/8/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

protocol Constructable {
    init(data: NSDictionary)
    
    var id: Int { get }
    
    func canConstruct(resources: [Int: Int]) -> Int
}
