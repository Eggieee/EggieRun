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
    
    init(objects: [T]) {
        for object in objects {
            addObject(object, weightage: 1)
        }
    }
    
    init(objects: [T], weightages: [Int]) {
        if objects.count != weightages.count {
            fatalError()
        }
        for i in 0 ..< objects.count {
            addObject(objects[i], weightage: weightages[i])
        }
    }
    
    init() {
    }
    
    func addObject(object: T, weightage: Int) {
        if weightage <= 0 {
            fatalError()
        }
        objects.append(object)
        weightages.append((weightages.last ?? 0) + weightage)
    }
    
    func draw() -> T {
        if objects.isEmpty {
            fatalError()
        }
        let chosenIndex = Int(arc4random_uniform(UInt32(weightages.last!)))
        for i in 0 ..< objects.count {
            if chosenIndex < weightages[i] {
                return objects[i]
            }
        }
        fatalError()
    }
}
