//
//  DexStorageController.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/21/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit
import CoreData

class DexStorageController {
    
    static let singleton = DexStorageController()
    
    private static let EGGDEX_FILENAME = "eggdex.data"
    
    private let savePath : AnyObject
    
    private var activatedDishes = Set<Int>()
    private static let ACTIVATED_DISHES_KEY = "dishes"
    
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if paths.count > 0 {
            savePath = paths[0]
            readEggdex()
        } else {
            fatalError("unable to locate storage")
        }
    }
    
    private func pathForEggdex() -> String {
        return savePath.stringByAppendingPathComponent(DexStorageController.EGGDEX_FILENAME)
    }
    
    private func readEggdex() {
        let data = NSData(contentsOfFile: pathForEggdex())
        if data != nil {
            let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
            activatedDishes = Set(archiver.decodeObjectForKey(DexStorageController.ACTIVATED_DISHES_KEY) as! Array<Int>)
            archiver.finishDecoding()
        }
    }
    
    func isDishActivated(dishToTest: Dish) -> Bool {
        return activatedDishes.contains(dishToTest.rawValue)
    }
    
    func addNewActivatedDish(dishToAdd: Dish) -> Bool {
        activatedDishes.insert(dishToAdd.rawValue)
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(Array(activatedDishes), forKey: DexStorageController.ACTIVATED_DISHES_KEY)
        archiver.finishEncoding()
        
        return data.writeToFile(pathForEggdex(), atomically: true)
    }
}
