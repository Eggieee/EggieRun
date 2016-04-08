//
//  EndingLayer.swift
//  EggieRun
//
//  Created by  light on 2016/04/08.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class EndingLayer: SKSpriteNode {
    private var dish: Dish
    private var background: SKSpriteNode!
    private var beam: SKSpriteNode!
    private var beamAction: SKAction
    
    init(generatedDish: Dish) {
        let beamAtlas = SKTextureAtlas(named: "beam.atlas")
        let sortedBeamTextureNames = beamAtlas.textureNames.sort()
        let beamTextures = sortedBeamTextureNames.map({ beamAtlas.textureNamed($0) })
        beamAction = SKAction.repeatActionForever(SKAction.animateWithTextures(beamTextures, timePerFrame: 0.005))
        
        dish = generatedDish
        super.init(texture: nil, color: UIColor.clearColor(), size: UIScreen.mainScreen().bounds.size)
        fadeInBackground()
        displayDish()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fadeInBackground() {
        background = SKSpriteNode(imageNamed: "ending-background")
        background.alpha = 0
        background.zPosition = 0
        addChild(background)
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        background.runAction(fadeInAction)
    }
    
    private func displayDish() {
        let dishImage = SKSpriteNode(imageNamed: "smashed-egg")
        let scaleUpAction = SKAction.scaleTo(1, duration: 0.5)
        dishImage.setScale(0)
        dishImage.zPosition = 2
        addChild(dishImage)
        dishImage.alpha = 1
        dishImage.runAction(scaleUpAction, completion: { () -> Void in
            self.beam = SKSpriteNode(imageNamed: "ending-beam-1")
            self.beam.zPosition = 1
            self.addChild(self.beam)
            self.beam.runAction(self.beamAction)
        })
    }
}