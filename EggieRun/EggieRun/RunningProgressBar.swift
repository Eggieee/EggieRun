//
//  RunningProgressBar.swift
//  EggieRun
//
//  Created by  light on 4/16/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

import SpriteKit

class RunningProgressBar: SKSpriteNode {
    private static let BAR_LENGTH: CGFloat = 800
    private static let BAR_HEIGHT: CGFloat = 10
    private static let MAX_DISTANCE = 100000
    
    private var distance = 0
    private var distanceBar: SKSpriteNode!
    
    init() {
        super.init(texture: nil, color: UIColor.grayColor(), size: CGSizeMake(RunningProgressBar.BAR_LENGTH, RunningProgressBar.BAR_HEIGHT))
        anchorPoint.x = 0
        anchorPoint.y = 1
        initializeBar()
    }
    
    private func initializeBar() {
        distanceBar = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(getNewDistanceBarLength(), RunningProgressBar.BAR_HEIGHT))
        distanceBar.anchorPoint.x = 0
        distanceBar.anchorPoint.y = 1
        addChild(distanceBar)
    }

    func updateDistance(movedDistance: Double) {
        distance += Int(movedDistance)
        distanceBar.size.width = getNewDistanceBarLength()
    }
    
    private func getNewDistanceBarLength() -> CGFloat {
        return RunningProgressBar.BAR_LENGTH * CGFloat(distance) / CGFloat(RunningProgressBar.MAX_DISTANCE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}