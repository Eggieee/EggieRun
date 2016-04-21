//
//  PlatformFactoryStab.swift
//  EggieRun
//
//  Created by Liu Yang on 20/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: ClosetFactory
// Description: a class computing the next closet’s position and length based 
// on certain formula.

import SpriteKit

class ClosetFactory {
    private static let MAX_NUM_OF_MID_PIECE: UInt32 = 4
    
    private var isFirst = true
    
    func next() -> Platform {
        let numOfMid: Int
        
        if isFirst {
            numOfMid = 1
            isFirst = false
        } else {
            numOfMid = Int(arc4random() % (ClosetFactory.MAX_NUM_OF_MID_PIECE + 1))
        }
        
        return Platform.makeCloset(numOfMid)
    }
}