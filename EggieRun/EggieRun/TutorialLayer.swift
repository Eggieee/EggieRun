//
//  tutorialLayer.swift
//  EggieRun
//
//  Created by Tang Jiahui on 18/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit
import UIKit

class TutorialLayer: SKNode {
    static let tutorials = ["tut1","tut2","tut3","tut4"]
    static private let TUTORIAL_WIDTH = CGFloat(600)
    static private let TUTORIAL_HEIGHT = CGFloat(450)
    static private let BUTTON_ENABLED_ALPHA = CGFloat(1)
    static private let BUTTON_DISABLED_ALPHA = CGFloat(0.5)
    
    static private let FILTER = CIFilter(name: "CIBlendWithMask", withInputParameters: ["inputMaskImage": CIImage(image: UIImage(named: "tutorial-mask")!)!])
    
    private static let FLIP_BUTTON_WIDTH = CGFloat(60)
    private static let FLIP_BUTTON_HEIGHT = CGFloat(60)

    private let midX: CGFloat
    private let midY: CGFloat
    
    var tutorialNode: SKSpriteNode
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
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        effectNode.filter = TutorialLayer.FILTER
        effectNode.addChild(tutorialNode)
        addChild(effectNode)
        
        nextPageNode.position = CGPoint(x: midX + TutorialLayer.TUTORIAL_WIDTH/2 +  TutorialLayer.FLIP_BUTTON_WIDTH/2 , y: midY)
        nextPageNode.size = CGSize(width: TutorialLayer.FLIP_BUTTON_WIDTH, height: TutorialLayer.FLIP_BUTTON_HEIGHT)
        addChild(nextPageNode)
        
        prevPageNode.position = CGPoint(x: midX - TutorialLayer.TUTORIAL_WIDTH/2 -  TutorialLayer.FLIP_BUTTON_WIDTH/2, y: midY)
        prevPageNode.size = CGSize(width: TutorialLayer.FLIP_BUTTON_WIDTH, height: TutorialLayer.FLIP_BUTTON_HEIGHT)
        prevPageNode.alpha = TutorialLayer.BUTTON_DISABLED_ALPHA
        addChild(prevPageNode)
    }
    
    // // generate the next tutorial page
    func getNextTutorial() {
        if currPage < TutorialLayer.tutorials.count - 1 {
            currPage += 1
            tutorialNode.texture = SKTexture(imageNamed: TutorialLayer.tutorials[currPage])
            prevPageNode.alpha = TutorialLayer.BUTTON_ENABLED_ALPHA
        } else {
            nextPageNode.alpha = TutorialLayer.BUTTON_DISABLED_ALPHA
        }
    }
    
    // generate the previous tutorial page
    func getPrevTutorial() {
        if currPage > 0 {
            currPage -= 1
            tutorialNode.texture = SKTexture(imageNamed: TutorialLayer.tutorials[currPage])
            nextPageNode.alpha = TutorialLayer.BUTTON_ENABLED_ALPHA
        } else {
            prevPageNode.alpha = TutorialLayer.BUTTON_DISABLED_ALPHA
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}