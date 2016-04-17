//
//  ShelfFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class ShelfFactory {
    private static let MAX_NUM_OF_MID_PIECE: UInt32 = 2
    private static let MAX_NUM_OF_GAP: UInt32 = 20
    private static let MIN_NUM_OF_GAP: UInt32 = 1

    private static let UNIT_GAP_SIZE: CGFloat = 100
    
    func nextPlatform() -> Shelf {
        let numOfMid = Int(arc4random() % (ShelfFactory.MAX_NUM_OF_MID_PIECE + 1))
        let numOfGap = CGFloat(arc4random() % (ShelfFactory.MAX_NUM_OF_GAP - ShelfFactory.MIN_NUM_OF_GAP + 1) + ShelfFactory.MIN_NUM_OF_GAP)

        return Shelf(numOfMidPiece: numOfMid, gapSize: numOfGap * ShelfFactory.UNIT_GAP_SIZE)
    }
}