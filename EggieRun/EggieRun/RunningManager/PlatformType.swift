//
//  PlatformType.swift
//  EggieRun
//
//  Created by Liu Yang on 17/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit

enum PlatformType: Int {
    case Closet = 0, Shelf
    
    private static let LEFT_IMAGE_NAMES = ["closet-left", "shelf-left"]
    private static let MIDDLE_IMAGE_NAMES = ["closet-middle", "shelf-middle"]
    private static let RIGHT_IMAGE_NAMES = ["closet-right", "shelf-right"]
    private static let BASELINE_HEIGHTS: [CGFloat] = [0, 300]

    var imageNameLeft: String {
        return PlatformType.LEFT_IMAGE_NAMES[rawValue]
    }
    
    var imageNameMiddle: String {
        return PlatformType.MIDDLE_IMAGE_NAMES[rawValue]
    }
    
    var imageNameRight: String {
        return PlatformType.RIGHT_IMAGE_NAMES[rawValue]
    }
    
    var height: CGFloat {
        return PlatformType.BASELINE_HEIGHTS[rawValue]
    }
}
