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
    private static let WIDTH_RATIO = CGFloat(2/3.0)
    private static let HEIGHT_RATIO = CGFloat(7/12.0)
    private static let OVERLAY_Z_POSITION = CGFloat(1)
    private static let QUESTION_Z_POSITION = CGFloat(2)
    private static let MINOR_OFFSET = CGFloat(20)
    private static let DISH_NAME_FONTSIZE = CGFloat(25)
    private static let DISH_DESCRIPTION_FONTSIZE = CGFloat(20)
    private static let DISH_DESCRIPTION_LEADING = 20
    private static let NAME_FONT = "Chalkduster"
    
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
        dishDescriptionNode = MultilineLabelNode(text: "", labelWidth: Int(WIDTH * DexDetailNode.WIDTH_RATIO) , pos: CGPoint(x: WIDTH / 2 + DexDetailNode.MINOR_OFFSET, y: HEIGHT / 3 - DexDetailNode.MINOR_OFFSET), fontName: "BradleyHandITCTT-Bold",fontSize: DexDetailNode.DISH_DESCRIPTION_FONTSIZE,fontColor: UIColor.blackColor(),leading: DexDetailNode.DISH_DESCRIPTION_LEADING, alignment:.Center)
        questionMarkNode = SKLabelNode(text: "?")
        
        effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        
        // background
        super.init(texture: SKTexture(imageNamed: "notebook"), color: UIColor.brownColor(), size: CGSize(width: WIDTH, height: HEIGHT))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x: sceneWidth * (1 - DexScene.DETAIL_WIDTH_RATIO), y: 0)
        
        dishImageNode.position = CGPoint(x: WIDTH / 2, y: sceneHeight * DexDetailNode.HEIGHT_RATIO)
        dishImageNode.size = CGSize(width: WIDTH * DexDetailNode.WIDTH_RATIO, height: WIDTH * DexDetailNode.WIDTH_RATIO)
        
        dishNameNode.position = CGPoint(x: WIDTH / 2 + DexDetailNode.MINOR_OFFSET, y: HEIGHT / 3 + DexDetailNode.MINOR_OFFSET)
        dishNameNode.fontSize = DexDetailNode.DISH_NAME_FONTSIZE
        dishNameNode.fontName = DexDetailNode.NAME_FONT
        dishNameNode.fontColor = UIColor.brownColor()
        
        questionMarkNode.color = UIColor.whiteColor()
        questionMarkNode.position = dishImageNode.position
        questionMarkNode.fontSize = DexDetailNode.QMARK_FONTSIZE
        questionMarkNode.verticalAlignmentMode = .Center
        questionMarkNode.zPosition = DexDetailNode.QUESTION_Z_POSITION
        questionMarkNode.hidden = true
        
        effectNode.zPosition = DexDetailNode.OVERLAY_Z_POSITION
        dishDescriptionNode.zPosition = DexDetailNode.OVERLAY_Z_POSITION
        dishNameNode.zPosition = DexDetailNode.OVERLAY_Z_POSITION
        
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
