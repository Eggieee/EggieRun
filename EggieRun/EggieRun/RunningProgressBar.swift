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
    static let MAX_DISTANCE = Milestone.ALL_VALUES.last!.requiredDistance
    private static let BUBBLE_Y: CGFloat = 6.0
    private static let BACKGROUND_COLOUR = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1)
    private static let MILESTONE_APPROACHING_DISTANCE = 2000
    private static let MILESTONE_APPROACHING_DURATION = 0.25
    private static let MILESTONE_APPROACHING_ACTION_KEY = "approaching"
    private static let MILESTONE_APPROACHING_ENLARGE = SKAction.scaleTo(2, duration: RunningProgressBar.MILESTONE_APPROACHING_DURATION)
    private static let MILESTONE_APPROACHING_SHRINK = SKAction.scaleTo(1, duration: RunningProgressBar.MILESTONE_APPROACHING_DURATION)
    private static let MILESTONE_APPROACHING_ACTIONS = SKAction.sequence([MILESTONE_APPROACHING_ENLARGE, MILESTONE_APPROACHING_SHRINK])
    
    private var barLength: CGFloat
    private var distance = 0
    private var barBorder: SKSpriteNode!
    private var progressBar: SKCropNode!
    private var distanceBar: SKSpriteNode!
    private var backgroundBar: SKSpriteNode!
    private let milestones: [Milestone]
    private var milestoneBubbles = [SKSpriteNode]()
    private var nextIndex = 0 {
        didSet {
            nextMilestone = milestones[nextIndex]
            nextMilestoneBubble = milestoneBubbles[nextIndex]
        }
    }
    private var nextMilestone: Milestone!
    private var nextMilestoneBubble: SKSpriteNode!
    
    init(length: CGFloat, allMilestones: [Milestone]) {
        barLength = length
        milestones = allMilestones
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(barLength, RunningProgressBar.BAR_HEIGHT))
        anchorPoint = CGPointMake(0, 1)
        initializeBar()
        initializeMilestones()
        nextMilestone = milestones[nextIndex]
        nextMilestoneBubble = milestoneBubbles[nextIndex]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDistance(movedDistance: Double) {
        distance += Int(movedDistance)
        distanceBar.size.width = getNewDistanceBarLength()
        if distance > nextMilestone.requiredDistance - RunningProgressBar.MILESTONE_APPROACHING_DISTANCE && nextMilestoneBubble.actionForKey(RunningProgressBar.MILESTONE_APPROACHING_ACTION_KEY) == nil {
            nextMilestoneBubble.runAction(RunningProgressBar.MILESTONE_APPROACHING_ACTIONS, withKey: RunningProgressBar.MILESTONE_APPROACHING_ACTION_KEY)
        }
    }
    
    func activateCurrentMilestone() {
        nextMilestoneBubble.texture = nextMilestone.colouredTexture
        if(nextIndex < milestones.count - 1) {
            nextIndex += 1
        }
    }
    
    
    private func initializeBar() {
        initializeBarBorder()
        initializeProgressBar()
    }
    
    private func initializeBarBorder() {
        barBorder = SKSpriteNode(imageNamed: "progress-bar-border")
        barBorder.anchorPoint = CGPointMake(0, 1)
        barBorder.size.width = barLength
        barBorder.position.y = 2.5
        barBorder.zPosition = 1
        addChild(barBorder)
    }
    
    private func initializeProgressBar() {
        progressBar = SKCropNode()
        progressBar.zPosition = 1
        cropProgressBar()
        initializeDistanceBar()
        initializeBackgroundBar()

        addChild(progressBar)
        progressBar.addChild(backgroundBar)
        progressBar.addChild(distanceBar)
    }
    
    private func cropProgressBar() {
        let maskNode = SKSpriteNode(imageNamed: "progress-bar-mask")
        maskNode.anchorPoint = CGPointMake(0, 1)
        maskNode.size.width = barLength
        progressBar.maskNode = maskNode
    }
    
    private func initializeDistanceBar() {
        distanceBar = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(getNewDistanceBarLength(), RunningProgressBar.BAR_HEIGHT))
        distanceBar.zPosition = 0
        distanceBar.anchorPoint = CGPointMake(0, 1)
    }
    
    private func initializeBackgroundBar() {
        backgroundBar = SKSpriteNode(texture: nil, color: RunningProgressBar.BACKGROUND_COLOUR, size: CGSizeMake(barLength, RunningProgressBar.BAR_HEIGHT))
        backgroundBar.zPosition = 0
        backgroundBar.anchorPoint = CGPointMake(0, 1)
    }
    
    private func initializeMilestones() {
        milestoneBubbles = [SKSpriteNode]()
        for milestone in milestones {
            let milestoneBubble = SKSpriteNode(texture: milestone.monochromeTexture)
            let xPosition = CGFloat(milestone.requiredDistance) / CGFloat(RunningProgressBar.MAX_DISTANCE) * barLength
            milestoneBubble.position = CGPointMake(xPosition, RunningProgressBar.BUBBLE_Y)
            milestoneBubble.zPosition = 2
            milestoneBubbles.append(milestoneBubble)
            addChild(milestoneBubble)
        }
    }

    private func getNewDistanceBarLength() -> CGFloat {
        return barLength * CGFloat(distance) / CGFloat(RunningProgressBar.MAX_DISTANCE)
    }
}