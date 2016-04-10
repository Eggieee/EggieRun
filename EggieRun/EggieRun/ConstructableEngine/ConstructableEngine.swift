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
    private let storage: ConstructableStorage<C>
    
    init(dataUrl: NSURL, storageFileName: String, storageKey: String) {
        NSLog("Initializing ConstructableEngine from dataUrl %@", dataUrl)
        
        let data = NSArray(contentsOfURL: dataUrl)!
        for element in data {
            let itemData = element as! NSDictionary
            constructables.append(C(data: itemData))
        }
        
        storage = ConstructableStorage<C>(storageFileName: storageFileName, storageKey: storageKey)
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
        
        var constructResult: C?
        
        if forceAppearConstructable != nil {
            constructResult = forceAppearConstructable!
        } else {
            constructResult = randomPool.draw()
        }
        if !storage.activate(constructResult!) {
            NSLog("ConstructableStorage save failed!")
        }
        return constructResult!
    }
    
    func isConstructableActivated(item: C) -> Bool {
        return storage.isActivated(item)
    }
    
    func clearActivated() -> Bool {
        return storage.clearActivated()
    }
}
