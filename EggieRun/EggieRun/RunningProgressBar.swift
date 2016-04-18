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
    private static let BAR_HEIGHT: CGFloat = 10
    private static let MAX_DISTANCE = 100000
    private static let BUBBLE_Y: CGFloat = 0.0
    
    private var barLength: CGFloat
    private var distance = 0
    private var distanceBar: SKSpriteNode!
    private let milestones: [Milestone]
    private var nextMilestone: Milestone
    
    init(length: CGFloat, allMilestones: [Milestone]) {
        barLength = length
        milestones = allMilestones
        nextMilestone = milestones[0]
        super.init(texture: nil, color: UIColor.grayColor(), size: CGSizeMake(barLength, RunningProgressBar.BAR_HEIGHT))
        anchorPoint.x = 0
        anchorPoint.y = 1
        initializeBar()
        initializeMilestones()
    }
    
    private func initializeBar() {
        distanceBar = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(getNewDistanceBarLength(), RunningProgressBar.BAR_HEIGHT))
        distanceBar.anchorPoint.x = 0
        distanceBar.anchorPoint.y = 1
        addChild(distanceBar)
    }
    
    private func initializeMilestones() {
        for milestone in milestones {
            //let bubbleTexture = SKTexture(imageNamed: "mono-milestone-template")
            let milestoneBubble = SKSpriteNode(imageNamed: "mono-milestone-template")
            let xPosition = CGFloat(milestone.requiredDistance) / CGFloat(RunningProgressBar.MAX_DISTANCE) * barLength
            milestoneBubble.position = CGPointMake(xPosition, RunningProgressBar.BUBBLE_Y)
            addChild(milestoneBubble)
        }
    }

    func updateDistance(movedDistance: Double) {
        distance += Int(movedDistance)
        distanceBar.size.width = getNewDistanceBarLength()
    }
    
    private func getNewDistanceBarLength() -> CGFloat {
        return barLength * CGFloat(distance) / CGFloat(RunningProgressBar.MAX_DISTANCE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}