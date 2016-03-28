//
//  RandomPool.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/26/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

class RandomPool<T> {
    private var objects = [T]()
    private var weightages = [Int]()
    private var totalWeightage = 0
    
    init(objects: [T]) {
        for object in objects {
            addObject(object, weightage: 1)
        }
    }
    
    init() {
        
    }
    
    func addObject(object: T, weightage: Int) {
        if weightage <= 0 {
            fatalError()
        }
        objects.append(object)
        totalWeightage += weightage
        weightages.append(totalWeightage)
    }
    
    func draw() -> T {
        if objects.isEmpty {
            fatalError()
        }
        let chosenIndex = Int(arc4random_uniform(UInt32(totalWeightage)))
        for i in 0..<objects.count {
            if chosenIndex < weightages[i] - 1 {
                return objects[i-1]
            }
        }
        return objects.last!
    }
}
