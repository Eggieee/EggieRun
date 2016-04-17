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
    
    private static let CLOSET_BASELINE_HEIGHT: CGFloat = 0
    private static let SHELF_BASELINE_HEIGHT: CGFloat = 300
    
    var imageNameLeft: String {
        return self == .Closet ? "closet-left" : "shelf-left"
    }
    
    var imageNameMiddle: String {
        return self == .Closet ? "closet-middle" : "shelf-middle"
    }
    
    var imageNameRight: String {
        return self == .Closet ? "closet-right" : "shelf-right"
    }
    
    var height: CGFloat {
        return self == .Closet ? PlatformType.CLOSET_BASELINE_HEIGHT : PlatformType.SHELF_BASELINE_HEIGHT
    }
}
