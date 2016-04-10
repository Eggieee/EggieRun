//
//  DexDetailNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 8/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexDetailNode: SKSpriteNode {
    var dishImageNode: SKSpriteNode
    var dishNameNode: SKLabelNode
    var dishDescriptionNode: SKLabelNode
    
    var dish: Dish? {
        didSet {
            if dish != nil {
                dishImageNode.texture = SKTexture(imageNamed: dish!.imageNamed)
                dishNameNode.text = dish!.name
                dishDescriptionNode.text = dish!.description
            } else {
                
            }
        }
    }
    
    init(sceneHeight: CGFloat, sceneWidth:CGFloat) {
        dishImageNode = SKSpriteNode(texture: nil)
        dishNameNode = SKLabelNode(text: "")
        dishDescriptionNode = SKLabelNode(text: "")
        
        // background
        super.init(texture: SKTexture(imageNamed:"detail-texture"), color: UIColor.brownColor(), size: CGSize(width: 3*sceneWidth/7, height: sceneHeight-80))
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x:4*sceneWidth/7, y:0)
        
        dishImageNode.position = CGPoint(x: self.frame.width/2,y: 7*sceneHeight/12)
        dishImageNode.size = CGSize(width: 2*self.frame.width/3, height: 2*self.frame.width/3)
        
        dishNameNode.position = CGPoint(x: self.frame.width/2,y: self.frame.height/4)
        dishNameNode.fontSize = 30
        dishNameNode.fontName = "BradleyHandITCTT-Bold"
        dishNameNode.fontColor = UIColor.blackColor()
        
        
        dishDescriptionNode.position = CGPoint(x: self.frame.width/2,y: self.frame.height/5)
        dishDescriptionNode.fontSize = 20
        dishDescriptionNode.fontColor = UIColor.blackColor()
        
        dishImageNode.zPosition = 1
        dishDescriptionNode.zPosition = 1
        dishNameNode.zPosition = 1
        
        addChild(dishImageNode)
        addChild(dishNameNode)
        addChild(dishDescriptionNode)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
