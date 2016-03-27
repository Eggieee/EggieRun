//
//  PlatformFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 20/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

protocol PlatformFactory {
    func nextPlatform() -> Platform
}
