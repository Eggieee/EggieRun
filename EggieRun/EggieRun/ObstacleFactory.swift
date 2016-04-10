//
//  ObstacleFactory.swift
//  EggieRun
//
//  Created by Liu Yang on 10/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import UIKit

class ObstacleFactory {
    private static let COOKER_TYPE_COUNT = 3

    func nextObstacle() -> Obstacle {
//        return Obstacle(cooker: Cooker(rawValue: Int(arc4random()) % ObstacleFactory.COOKER_TYPE_COUNT + 1)!)
        return Obstacle(cooker: .Oven)
    }
}
