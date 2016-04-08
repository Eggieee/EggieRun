//
//  ConstructableEngine.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/8/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

class ConstructableEngine<C: Constructable> {
    
    private(set) var constructables = [C]()
    
    init(url: NSURL) {
        let data = NSArray(contentsOfURL: url)!
        for element in data {
            let itemData = element as! NSDictionary
            constructables.append(C(data: itemData))
        }
    }
    
    func getConstructResult(resources: [Int: Int]) -> C {
        let randomPool = RandomPool<C>()
        
        var forceAppearConstructablePriority = 0
        var forceAppearConstructable: C?
        
        for constructable in constructables {
            let thisCanConstruct = constructable.canConstruct(resources)
            
            if thisCanConstruct < forceAppearConstructablePriority {
                forceAppearConstructablePriority = thisCanConstruct
                forceAppearConstructable = constructable
            } else if thisCanConstruct > 0 {
                randomPool.addObject(constructable, weightage: thisCanConstruct)
            }
        }
        
        if forceAppearConstructable != nil {
            return forceAppearConstructable!
        } else {
            return randomPool.draw()
        }
    }
}
