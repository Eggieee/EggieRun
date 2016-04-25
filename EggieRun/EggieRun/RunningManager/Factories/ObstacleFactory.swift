//
//  ObstacleFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 10/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: ClosetFactory
// Description: a class computing next obstacle to generate based on 
// certain formula and current distance of running.

import UIKit

class ObstacleFactory {
    func next(availableCookers: [Cooker]) -> Obstacle {
        let type = availableCookers[Int(arc4random_uniform(UInt32(availableCookers.count)))]
        
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
 