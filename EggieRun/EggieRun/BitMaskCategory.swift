//
//  Bitmasks.swift
//  EggieRun
//
//  Created by Liu Yang on 19/3/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit

struct BitMaskCategory {
    static let scene: UInt32 = 1 << 0
    static let hero: UInt32 = 1 << 1
    static let platform: UInt32 = 1 << 2
    static let collectable: UInt32 = 1 << 3
    static let cooker: UInt32 = 1 << 4
}