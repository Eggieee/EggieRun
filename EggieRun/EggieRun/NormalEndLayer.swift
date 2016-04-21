//
//  EndingLayer.swift
//  EggieRun
//
//  Created by  light on 2016/04/08.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class NormalEndLayer: SKSpriteNode {
    private var dish: Dish
    private var background: SKSpriteNode!
    private var bar: SKSpriteNode!
    private(set) var eggdexButton: SKSpriteNode!
    private(set) var playButton: SKSpriteNode!
    private var beam: SKSpriteNode!
    private var beamAction: SKAction
    private static let BEAM_TIME_PER_FRAME = 0.005
    private static let BACKGROUND_Z_POSITION: CGFloat = 0
    private static let BAR_Y_POSITION: CGFloat = -291
    private static let BUTTON_Y_POSITION: CGFloat = -330
    private static let BUTTON_X_POSITION: CGFloat = -220
    private static let BUTTON_Z_POSITION: CGFloat = 1
    private static let DISH_Z_POSITION: CGFloat = 2
    private static let TITLE_Y_POSITION: CGFloat = 250
    private static let BEAM_Z_POSITION: CGFloat = 1
    private static let STAR_DISTANCE = 80
    private static let ACTION_DURATION: Double = 0.5
    private static let STAR_ANIMATION_DURATION: Double = 2
    private static let STAR_BIG_SCALE: CGFloat = 5
    
    init(usedCooker: Cooker, generatedDish: Dish, isNew: Bool) {
        let beamAtlas = SKTextureAtlas(named: "beam.atlas")
        let sortedBeamTextureNames = beamAtlas.textureNames.sort()
        let beamTextures = sortedBeamTextureNames.map({ beamAtlas.textureNamed($0) })
        beamAction = SKAction.repeatActionForever(SKAction.animateWithTextures(beamTextures, timePerFrame: NormalEndLayer.BEAM_TIME_PER_FRAME))
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
        background.zPosition = NormalEndLayer.BACKGROUND_Z_POSITION
        fadeIn(background)
    }
    
    private func fadeInBar() {
        bar = SKSpriteNode(imageNamed: "ending-bar")
        bar.zPosition = NormalEndLayer.BACKGROUND_Z_POSITION
        bar.position.y = NormalEndLayer.BAR_Y_POSITION
        fadeIn(bar)
    }
    
    private func fadeInButton() {
        eggdexButton = SKSpriteNode(imageNamed: "ending-eggdex-button")
        eggdexButton.zPosition = NormalEndLayer.BUTTON_Z_POSITION
        eggdexButton.position.y = NormalEndLayer.BUTTON_Y_POSITION
        eggdexButton.position.x = NormalEndLayer.BUTTON_X_POSITION
        
        playButton = SKSpriteNode(imageNamed: "ending-play-button")
        playButton.zPosition = NormalEndLayer.BUTTON_Z_POSITION
        playButton.position.y = NormalEndLayer.BUTTON_Y_POSITION
        playButton.position.x = -NormalEndLayer.BUTTON_X_POSITION
        
        fadeIn(eggdexButton)
        fadeIn(playButton)
    }
    
    private func fadeIn(node: SKSpriteNode) {
        node.alpha = 0
        addChild(node)
        let fadeInAction = SKAction.fadeInWithDuration(NormalEndLayer.ACTION_DURATION)
        node.runAction(fadeInAction)
    }
    
    private func displayDish() {
        let dishImage = SKSpriteNode(texture: dish.texture)
        let scaleUpAction = SKAction.scaleTo(1, duration: NormalEndLayer.ACTION_DURATION)
        dishImage.setScale(0)
        dishImage.zPosition = NormalEndLayer.DISH_Z_POSITION
        addChild(dishImage)
        dishImage.alpha = 1
        dishImage.runAction(scaleUpAction, completion: { () -> Void in
            self.animateBeam()
        })
    }
    
    private func displayTitle() {
        let dishTitle = SKSpriteNode(imageNamed: dish.titleImageNamed)
        let scaleUpAction = SKAction.scaleTo(1, duration: NormalEndLayer.ACTION_DURATION)
        dishTitle.setScale(0)
        dishTitle.zPosition = NormalEndLayer.DISH_Z_POSITION
        dishTitle.position.y = NormalEndLayer.TITLE_Y_POSITION
        addChild(dishTitle)
        dishTitle.alpha = 1
        dishTitle.runAction(scaleUpAction)
    }
    
    private func animateBeam() {
        beam = SKSpriteNode(imageNamed: "ending-beam-1")
        beam.zPosition = NormalEndLayer.BEAM_Z_POSITION
        addChild(beam)
        beam.runAction(beamAction)
    }
    
    private func showStars(count: Int) {
        let distance = NormalEndLayer.STAR_DISTANCE
        let halfCount: Int = count / 2
        let evenFirstXPosition = -(distance / 2 + (halfCount - 1) * distance)
        let oddFirstXPosition = -(halfCount * distance)
        let firstXPosition = (count % 2 == 0) ?  evenFirstXPosition : oddFirstXPosition
        var starActions = [SKAction]()
        for i in 0..<count {
            let currentXPosition = CGFloat(firstXPosition + distance * i)
            let currentStar = SKSpriteNode(imageNamed: "ending-star")
            currentStar.position.x = currentXPosition
            currentStar.position.y = -NormalEndLayer.TITLE_Y_POSITION
            currentStar.zPosition = NormalEndLayer.DISH_Z_POSITION
            starActions.append(SKAction.runBlock({ () -> Void in
                self.animateStar(currentStar)
            }))
        }
        runAction(SKAction.sequence(starActions))
    }
    
    private func animateStar(star: SKSpriteNode) {
        star.setScale(NormalEndLayer.STAR_BIG_SCALE)
        star.alpha = 0
        let scaleDownAction = SKAction.scaleTo(1, duration: NormalEndLayer.ACTION_DURATION)
        let fadeInAction = SKAction.fadeInWithDuration(NormalEndLayer.ACTION_DURATION)
        addChild(star)
        let waitAction = SKAction.waitForDuration(NormalEndLayer.STAR_ANIMATION_DURATION)
        let group = SKAction.group([scaleDownAction, fadeInAction])
        let sequence = SKAction.sequence([group, waitAction])
        star.runAction(sequence)
    }
}
