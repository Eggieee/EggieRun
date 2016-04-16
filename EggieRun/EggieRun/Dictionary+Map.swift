//
//  Dictionary+Map.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/11/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    func map<OutValue>(@noescape transform: Value throws -> OutValue) rethrows -> [Key: OutValue] {
        return Dictionary<Key, OutValue>(try map { (k, v) in (k, try transform(v)) })
    }
}
