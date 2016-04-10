//
//  ConstructableStorage.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/10/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

class ConstructableStorage<C: Constructable> {
    
    private let storagePath: AnyObject
    private let storageFileName: String
    private let storageKey: String
    
    private var activatedConstructableIds = Set<Int>()
    
    init(storageFileName: String, storageKey: String) {
        NSLog("Initializing ConstructableStorage from file %@", storageFileName)
        
        self.storageFileName = storageFileName
        self.storageKey = storageKey
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if paths.count > 0 {
            storagePath = paths[0]
            readData()
        } else {
            fatalError("unable to locate storage")
        }
    }
    
    private func path() -> String {
        return storagePath.stringByAppendingPathComponent(storageFileName)
    }
    
    private func readData() {
        let data = NSData(contentsOfFile: path())
        if data != nil {
            let archiver = NSKeyedUnarchiver(forReadingWithData: data!)
            activatedConstructableIds = Set(archiver.decodeObjectForKey(storageKey) as! Array<Int>)
            archiver.finishDecoding()
        }
        NSLog("ConstructableStorage read finished, data: %@", activatedConstructableIds.debugDescription)
    }
    
    private func writeData() -> Bool {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(Array(activatedConstructableIds), forKey: storageKey)
        archiver.finishEncoding()
        
        return data.writeToFile(path(), atomically: true)
    }
    
    func isActivated(item: C) -> Bool {
        return activatedConstructableIds.contains(item.id)
    }
    
    func activate(item: C) -> Bool {
        activatedConstructableIds.insert(item.id)
        return writeData()
    }
    
    func clearActivated() -> Bool {
        activatedConstructableIds.removeAll()
        return writeData()
    }
}
