//
//  DexDetailNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexDetailNode: SKSpriteNode {
    private static let QMARK_FONTSIZE = CGFloat(100)
    
    private let WIDTH : CGFloat
    private let HEIGHT: CGFloat
    private var dishImageNode: SKSpriteNode
    private var effectNode: SKEffectNode
    private var dishNameNode: SKLabelNode
    private var dishDescriptionNode: MultilineLabelNode
    private var questionMarkNode: SKLabelNode
    
    func setDish(dish: Dish, activated: Bool) {
        dishImageNode.texture = dish.texture
        if activated {
            effectNode.filter = nil
            dishDescriptionNode.text = dish.description
            dishNameNode.text = dish.name
            questionMarkNode.hidden = true
        } else {
            effectNode.filter = DexScene.UNACTIVATED_FILTER
            dishDescriptionNode.text = dish.hintDescription
            dishNameNode.text = "???"
            questionMarkNode.hidden = false
        }
    }
    
    init(sceneHeight: CGFloat, sceneWidth: CGFloat) {
        WIDTH = sceneWidth * DexScene.DETAIL_WIDTH_RATIO
        HEIGHT = sceneHeight - DexScene.TOP_BAR_HEIGHT
        
        dishImageNode = SKSpriteNode(texture: nil)
        dishNameNode = SKLabelNode(text: "")
        dishDescriptionNode = MultilineLabelNode(text: "", labelWidth: Int(WIDTH * 2/3) , pos: CGPoint(x: WIDTH / 2, y: HEIGHT / 3.5), fontName: "ChalkboardSE-Regular",fontSize:20,fontColor: UIColor.blackColor(),leading: 20, alignment:.Center)
        questionMarkNode = SKLabelNode(text: "?")
        
        effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        
        // background
        super.init(texture: SKTexture(imageNamed: "notebook"), color: UIColor.brownColor(), size: CGSize(width: WIDTH, height: HEIGHT))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x: sceneWidth * (1 - DexScene.DETAIL_WIDTH_RATIO), y: 0)
        
        dishImageNode.position = CGPoint(x: WIDTH / 2, y: 7 * sceneHeight / 12)
        dishImageNode.size = CGSize(width: 2 * WIDTH / 3, height: 2 * WIDTH / 3)
        
        dishNameNode.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 3)
        dishNameNode.fontSize = 30
        dishNameNode.fontName = "BradleyHandITCTT-Bold"
        dishNameNode.fontColor = UIColor.brownColor()
        
        questionMarkNode.color = UIColor.whiteColor()
        questionMarkNode.position = dishImageNode.position
        questionMarkNode.fontSize = DexDetailNode.QMARK_FONTSIZE
        questionMarkNode.verticalAlignmentMode = .Center
        questionMarkNode.zPosition = 2
        questionMarkNode.hidden = true
        
        effectNode.zPosition = 1
        dishDescriptionNode.zPosition = 1
        dishNameNode.zPosition = 1
        
        effectNode.addChild(dishImageNode)
        addChild(effectNode)
        addChild(dishNameNode)
        addChild(dishDescriptionNode)
        addChild(questionMarkNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
