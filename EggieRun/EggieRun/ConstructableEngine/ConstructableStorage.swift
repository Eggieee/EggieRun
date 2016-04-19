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
    
    private let ACTIVATION_KEY = "activation"
    private let NEW_FLAG_KEY = "new_flag"
    
    private(set) var activationSet = Set<Int>()
    private var newFlagSet = Set<Int>()
    
    init(storageFileName: String) {
        NSLog("Initializing ConstructableStorage from file %@", storageFileName)
        
        self.storageFileName = storageFileName
        
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
            activationSet = Set((archiver.decodeObjectForKey(ACTIVATION_KEY) as? Array<Int>) ?? [])
            newFlagSet = Set((archiver.decodeObjectForKey(NEW_FLAG_KEY) as? Array<Int>) ?? [])
            archiver.finishDecoding()
        }
        NSLog("ConstructableStorage read finished, data: %@", activationSet.debugDescription)
    }
    
    private func writeData() -> Bool {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(Array(activationSet), forKey: ACTIVATION_KEY)
        archiver.encodeObject(Array(newFlagSet), forKey: NEW_FLAG_KEY)
        archiver.finishEncoding()
        
        return data.writeToFile(path(), atomically: true)
    }
    
    func isActivated(item: C) -> Bool {
        return activationSet.contains(item.id)
    }
    
    func hasNewFlag(item: C) -> Bool {
        return newFlagSet.contains(item.id)
    }
    
    func activate(item: C) -> Bool {
        if isActivated(item) {
            return true
        } else {
            activationSet.insert(item.id)
            newFlagSet.insert(item.id)
            return writeData()
        }
    }
    
    func clearActivated() -> Bool {
        activationSet.removeAll()
        return writeData()
    }
    
    func clearNewFlag() -> Bool {
        newFlagSet.removeAll()
        return writeData()
    }
}
