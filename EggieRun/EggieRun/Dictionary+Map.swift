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
}
