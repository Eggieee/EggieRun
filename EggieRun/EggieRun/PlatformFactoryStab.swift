//
//  PlatformFactoryStab.swift
//  EggieRun
//
//  Created by Liu Yang on 20/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class PlatformFactoryStab: PRGPlatformFactory {
    func nextPlatform() -> PRGPlatform {
        let numOfMid = 1
        let gapSize = 300
        var images = [String]()
        images.append("closet-left")
        for _ in 0..<numOfMid {
            images.append("closet-middle")
        }
        images.append("closet-right")
        
        return PRGPlatform(imageNames: images, positionY: 0, followingGapSize: CGFloat(gapSize))
    }
}