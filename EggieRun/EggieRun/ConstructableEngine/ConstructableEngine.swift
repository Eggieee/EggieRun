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
    private var constructableIdsMap = [Int: C]()
    private let storage: ConstructableStorage<C>
    
    var activatedConstructables: [C] {
        return storage.activationSet.map({ constructableIdsMap[$0]! })
    }
    
    init(dataUrl: NSURL, storageFileName: String) {
        NSLog("Initializing ConstructableEngine from dataUrl %@", dataUrl)
        
        let data = NSArray(contentsOfURL: dataUrl)!
        for element in data {
            let constructable = C(data: element as! NSDictionary)
            constructables.append(constructable)
            constructableIdsMap[constructable.id] = constructable
        }
        
        storage = ConstructableStorage<C>(storageFileName: storageFileName)
    }
    
    
    func getConstructResult(resources: [Int: Int]) -> (C, Bool) {
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
        
        let newFlag = !storage.isActivated(constructResult!)
        if !storage.activate(constructResult!) {
            NSLog("ConstructableStorage save failed!")
        }
        
        return (constructResult!, newFlag)
    }
    
    func isConstructableActivated(item: C) -> Bool {
        return storage.isActivated(item)
    }
    
    func isConstructableNew(item: C) -> Bool {
        return storage.hasNewFlag(item)
    }
    
    func forceActivateConstructable(item: C) -> Bool {
        return storage.activate(item)
    }
    
    func clearNewFlags() -> Bool {
        return storage.clearNewFlag()
    }
    
    func clearActivated() -> Bool {
        return storage.clearActivated()
    }
}
