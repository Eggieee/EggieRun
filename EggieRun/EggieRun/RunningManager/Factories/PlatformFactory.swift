//
//  PlatformFactoryStab.swift
//  EggieRun
//
//  Created by Liu Yang on 20/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class PlatformFactory {
    private static let MAX_NUM_OF_MID_PIECE: UInt32 = 4
    
    private var isFirst = true
    
    func nextPlatform() -> Platform {
        let numOfMid: Int
        let type: PlatformType
        
        if isFirst {
            numOfMid = 1
            type = PlatformType(rawValue: 0)!
            isFirst = false
        } else {
//            type = PlatformType(rawValue: Int(arc4random() % 2))!
            type = .Shelf
            numOfMid = Int(arc4random() % (PlatformFactory.MAX_NUM_OF_MID_PIECE + 1))
        }
        
        return Platform(type: type, numOfMidPiece: numOfMid)
    }
}