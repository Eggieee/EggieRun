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
    private static let GAP_SIZE = 300
    
    func nextPlatform() -> Platform {
        let numOfMid = arc4random() % (PlatformFactory.MAX_NUM_OF_MID_PIECE + 1)
        
        var images = [String]()
        images.append("closet-left")
        for _ in 0..<numOfMid {
            images.append("closet-middle")
        }
        images.append("closet-right")
        
        return Platform(imageNames: images, positionY: 0, followingGapSize: CGFloat(PlatformFactory.GAP_SIZE))
    }
}