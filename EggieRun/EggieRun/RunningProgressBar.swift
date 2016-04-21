//
//  RunningProgressBar.swift
//  EggieRun
//
//  Created by  light on 4/16/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

// Class: RunningProgressBar
// Description: a progress bar showing where the eggie has been through.
// It also displays a couple of milestones on it. The milestones will
// turn colourful when the eggie has reached it.

import SpriteKit

class RunningProgressBar: SKSpriteNode {
    private static let STANDARD_ANCHOR_POINT: CGPoint = CGPointMake(0, 1)
    private static let BAR_HEIGHT: CGFloat = 10
    static let MAX_DISTANCE = Milestone.ALL_VALUES.last!.requiredDistance
    private static let BUBBLE_Y: CGFloat = 6.0
    private static let BACKGROUND_COLOUR = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1)
    private static let BAR_BORDER_Y_POSITION: CGFloat = 2.5
    private static let BAR_BORDER_Z_POSITION: CGFloat = 1
    private static let PROGRESS_BAR_Z_POSITION: CGFloat = 1
    private static let BAR_BACKGROUND_Z_POSITION: CGFloat = 0
    private static let MILESTONE_BUBBLE_Z_POSITION: CGFloat = 2
    private static let MILESTONE_APPROACHING_DISTANCE = 2000
    private static let MILESTONE_APPROACHING_DURATION = 0.25
    private static let BAR_BORDER_IMAGE_NAME = "progress-bar-border"
    private static let MASK_IMAGE_NAME = "progress-bar-mask"
    private static let MILESTONE_APPROACHING_ACTION_KEY = "approaching"
    private static let MILESTONE_APPROACHING_ACTIONS = SKAction.sequence([2, 1].map({ SKAction.scaleTo($0, duration: RunningProgressBar.MILESTONE_APPROACHING_DURATION) }))
    
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
        anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
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
        barBorder = SKSpriteNode(imageNamed: RunningProgressBar.BAR_BORDER_IMAGE_NAME)
        barBorder.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
        barBorder.size.width = barLength
        barBorder.position.y = RunningProgressBar.BAR_BORDER_Y_POSITION
        barBorder.zPosition = RunningProgressBar.BAR_BORDER_Z_POSITION
        addChild(barBorder)
    }
    
    private func initializeProgressBar() {
        progressBar = SKCropNode()
        progressBar.zPosition = RunningProgressBar.PROGRESS_BAR_Z_POSITION
        cropProgressBar()
        initializeDistanceBar()
        initializeBackgroundBar()

        addChild(progressBar)
        progressBar.addChild(backgroundBar)
        progressBar.addChild(distanceBar)
    }
    
    private func cropProgressBar() {
        let maskNode = SKSpriteNode(imageNamed: RunningProgressBar.MASK_IMAGE_NAME)
        maskNode.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
        maskNode.size.width = barLength
        progressBar.maskNode = maskNode
    }
    
    private func initializeDistanceBar() {
        distanceBar = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(getNewDistanceBarLength(), RunningProgressBar.BAR_HEIGHT))
        distanceBar.zPosition = RunningProgressBar.BAR_BACKGROUND_Z_POSITION
        distanceBar.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
    }
    
    private func initializeBackgroundBar() {
        backgroundBar = SKSpriteNode(texture: nil, color: RunningProgressBar.BACKGROUND_COLOUR, size: CGSizeMake(barLength, RunningProgressBar.BAR_HEIGHT))
        backgroundBar.zPosition = RunningProgressBar.BAR_BACKGROUND_Z_POSITION
        backgroundBar.anchorPoint = RunningProgressBar.STANDARD_ANCHOR_POINT
    }
    
    private func initializeMilestones() {
        milestoneBubbles = [SKSpriteNode]()
        for milestone in milestones {
            let milestoneBubble = SKSpriteNode(texture: milestone.monochromeTexture)
            let xPosition = CGFloat(milestone.requiredDistance) / CGFloat(RunningProgressBar.MAX_DISTANCE) * barLength
            milestoneBubble.position = CGPointMake(xPosition, RunningProgressBar.BUBBLE_Y)
            milestoneBubble.zPosition = RunningProgressBar.MILESTONE_BUBBLE_Z_POSITION
            milestoneBubbles.append(milestoneBubble)
            addChild(milestoneBubble)
        }
    }

    private func getNewDistanceBarLength() -> CGFloat {
        return barLength * CGFloat(distance) / CGFloat(RunningProgressBar.MAX_DISTANCE)
    }
}