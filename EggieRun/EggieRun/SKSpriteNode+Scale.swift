//
//  SKSpriteNode+Scale.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func scale(width: Double) {
        let aspectRatio = Double(size.height / size.width)
        size = CGSize(width: width, height: width * aspectRatio)
    }
}