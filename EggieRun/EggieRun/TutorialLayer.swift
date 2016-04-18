//
//  tutorialLayer.swift
//  EggieRun
//
//  Created by Tang Jiahui on 18/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit


class TutorialLayer: SKNode {
    static let tutorials = ["t1","t2"]
    static private let TUTORIAL_WIDTH = CGFloat(600)
    static private let TUTORIAL_HEIGHT = CGFloat(300)
    
    private static let FLIP_BUTTON_WIDTH = CGFloat(60)
    private static let FLIP_BUTTON_HEIGHT = CGFloat(60)

    private let midX: CGFloat
    private let midY: CGFloat
    
    private var tutorialNode: SKSpriteNode
    let nextPageNode: SKSpriteNode
    let prevPageNode: SKSpriteNode
    var currPage: Int

    
    init(frameWidth: CGFloat, frameHeight: CGFloat) {
        midX = frameWidth / 2
        midY = frameHeight / 2
        tutorialNode = SKSpriteNode(imageNamed: TutorialLayer.tutorials[0])
        currPage = 0
        nextPageNode = SKSpriteNode(imageNamed: "next-arrow")
        prevPageNode = SKSpriteNode(imageNamed: "prev-arrow")
        
        super.init()
        
        tutorialNode.position = CGPoint(x: midX, y: midY)
        tutorialNode.size = CGSize(width: TutorialLayer.TUTORIAL_WIDTH, height: TutorialLayer.TUTORIAL_HEIGHT)
        addChild(tutorialNode)
        
        nextPageNode.position = CGPoint(x: midX + TutorialLayer.TUTORIAL_WIDTH/2 +  TutorialLayer.FLIP_BUTTON_WIDTH/2 , y: midY)
        nextPageNode.size = CGSize(width: TutorialLayer.FLIP_BUTTON_WIDTH, height: TutorialLayer.FLIP_BUTTON_HEIGHT)
        addChild(nextPageNode)
        
        prevPageNode.position = CGPoint(x: midX - TutorialLayer.TUTORIAL_WIDTH/2 -  TutorialLayer.FLIP_BUTTON_WIDTH/2, y: midY)
        prevPageNode.size = CGSize(width: TutorialLayer.FLIP_BUTTON_WIDTH, height: TutorialLayer.FLIP_BUTTON_HEIGHT)
        addChild(prevPageNode)
    }
    
    func getNextTutorial() {
        currPage += 1
        tutorialNode.texture = SKTexture(imageNamed: TutorialLayer.tutorials[currPage])
    }
    
    func getPrevTutorial() {
        currPage -= 1
        tutorialNode.texture = SKTexture(imageNamed: TutorialLayer.tutorials[currPage])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}