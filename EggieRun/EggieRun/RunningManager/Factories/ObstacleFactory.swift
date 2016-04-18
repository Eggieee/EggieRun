//
//  ObstacleFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 10/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit

class ObstacleFactory {
    func nextObstacle(availableCookers: [Cooker]) -> Obstacle {
        let type = availableCookers[Int(arc4random()) % availableCookers.count]
        
        switch type {
        case .Pot:
            return Pot()
        case .Oven:
            return Oven()
        default:
            return Pan()
        }
    }
}
 