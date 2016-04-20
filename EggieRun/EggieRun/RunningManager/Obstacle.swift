//
//  Cooker.swift
//  EggieRun
//
//  Created by Liu Yang on 10/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class Obstacle: SKNode {
    static let WIDTH = 180.0
    static let ATLAS_TIME_PER_FRAME = 0.05
    static let ERROR_MESSAGE = "The class Obstacle should not be instantiated"
    
    let cookerType: Cooker!
    var isPassed = false
    var heightPadding: CGFloat = 0.0
    
    init(cooker: Cooker) {
        cookerType = cooker
        super.init()
        zPosition = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isDeadly(vector: CGVector, point: CGPoint) -> Bool {
        fatalError(Obstacle.ERROR_MESSAGE)
    }
    
    func animateClose() {
        fatalError(Obstacle.ERROR_MESSAGE)
    }
}