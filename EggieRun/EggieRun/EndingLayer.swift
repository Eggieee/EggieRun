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
    private var bar: SKSpriteNode!
    private var eggdexButton: SKSpriteNode!
    private var playButton: SKSpriteNode!
    private var beam: SKSpriteNode!
    private var beamAction: SKAction
    
    init(usedCooker: Cooker, generatedDish: Dish) {
        let beamAtlas = SKTextureAtlas(named: "beam.atlas")
        let sortedBeamTextureNames = beamAtlas.textureNames.sort()
        let beamTextures = sortedBeamTextureNames.map({ beamAtlas.textureNamed($0) })
        beamAction = SKAction.repeatActionForever(SKAction.animateWithTextures(beamTextures, timePerFrame: 0.005))
        
        dish = generatedDish
        super.init(texture: nil, color: UIColor.clearColor(), size: UIScreen.mainScreen().bounds.size)
        fadeInBackground()
        fadeInBar()
        fadeInButton()
        displayDish()
        displayTitle()
        showStars(generatedDish.rarity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fadeInBackground() {
        background = SKSpriteNode(imageNamed: "ending-background")
        background.zPosition = 0
        fadeIn(background)
    }
    
    private func fadeInBar() {
        bar = SKSpriteNode(imageNamed: "ending-bar")
        bar.zPosition = 0
        bar.position.y = -291
        fadeIn(bar)
    }
    
    private func fadeInButton() {
        eggdexButton = SKSpriteNode(imageNamed: "ending-eggdex-button")
        eggdexButton.zPosition = 1
        eggdexButton.position.y = -330
        eggdexButton.position.x = -220
        
        playButton = SKSpriteNode(imageNamed: "ending-play-button")
        playButton.zPosition = 1
        playButton.position.y = -330
        playButton.position.x = 220
        
        fadeIn(eggdexButton)
        fadeIn(playButton)
    }
    
    private func fadeIn(node: SKSpriteNode) {
        node.alpha = 0
        addChild(node)
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        node.runAction(fadeInAction)
    }
    
    private func displayDish() {
        let dishImage = SKSpriteNode(imageNamed: dish.imageNamed)
        let scaleUpAction = SKAction.scaleTo(1, duration: 0.5)
        dishImage.setScale(0)
        dishImage.zPosition = 2
        addChild(dishImage)
        dishImage.alpha = 1
        dishImage.runAction(scaleUpAction, completion: { () -> Void in
            self.animateBeam()
        })
    }
    
    private func displayTitle() {
        let dishTitle = SKSpriteNode(imageNamed: dish.titleImageNamed)
        let scaleUpAction = SKAction.scaleTo(1, duration: 0.5)
        dishTitle.setScale(0)
        dishTitle.zPosition = 2
        dishTitle.position.y = 250
        addChild(dishTitle)
        dishTitle.alpha = 1
        dishTitle.runAction(scaleUpAction)
    }
    
    private func animateBeam() {
        beam = SKSpriteNode(imageNamed: "ending-beam-1")
        beam.zPosition = 1
        addChild(beam)
        beam.runAction(beamAction)
    }
    
    private func showStars(count: Int) {
        let distance = 80
        let halfCount: Int = count / 2
        let firstXPosition = (count % 2 == 0) ?  -(distance / 2 + (halfCount - 1) * distance) : -(halfCount * distance)
        var starActions = [SKAction]()
        for i in 0..<count {
            let currentXPosition = CGFloat(firstXPosition + distance * i)
            let currentStar = SKSpriteNode(imageNamed: "ending-star")
            currentStar.position.x = currentXPosition
            currentStar.position.y = -250
            currentStar.zPosition = 2
            starActions.append(SKAction.runBlock({ () -> Void in
                self.animateStar(currentStar)
            }))
        }
        
        runAction(SKAction.sequence(starActions))
    }
    
    private func animateStar(star: SKSpriteNode) {
        star.setScale(5)
        star.alpha = 0
        let scaleDownAction = SKAction.scaleTo(1, duration: 0.5)
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        addChild(star)
        let waitAction = SKAction.waitForDuration(2)
        
        let group = SKAction.group([scaleDownAction, fadeInAction])
        let sequence = SKAction.sequence([group, waitAction])
        
        star.runAction(sequence)
    }
}
