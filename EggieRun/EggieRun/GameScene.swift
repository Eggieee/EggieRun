//
//  GameScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright (c) 2016 Eggieee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Constants
    private static let BACKGROUND_IMAGE_NAME = "default-background"
    private static let DISTANCE_LABEL_TEXT = "Distance: %dm"
    private static let HEADER_FONT_SIZE: CGFloat = 30
    private static let EGGIE_X_POSITION: CGFloat = 200
    private static let FIRST_COLLECTABLE_POSITION_X: CGFloat = 400
    private static let DISTANCE_PLATFORM_AND_COLLECTABLE: CGFloat = 200
    
    private enum GameState {
        case Ready, Playing, Over
    }
    
    private var eggie: Eggie!
    private var platformFactory: PlatformFactory!
    private var collectableFactory: CollectableFactory!
    private var ingredientBar: IngredientBar!
    private var flavourBar: FlavourBar!
    private var gameState: GameState = .Ready
    private var distanceLabel: SKLabelNode!
    private var distance = 0
    private var platforms: [Platform]!
    private var collectables: [Collectable]!
    private var lastUpdatedTime: CFTimeInterval!
    private var endingLayer: EndingLayer?

    override func didMoveToView(view: SKView) {
        initializePhysicsProperties()
        gameReady()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState == .Ready {
            gameStart()
        } else if gameState == .Playing && eggie.canJump {
            eggie.state = .Jumping
        } else if gameState == .Over && endingLayer != nil {
            let touch = touches.first!
            let touchLocation = touch.locationInNode(endingLayer!)
            
            if endingLayer!.eggdexButton.containsPoint(touchLocation) {
                let dexScene = DexScene(size: self.size)
                let transition = SKTransition.flipHorizontalWithDuration(0.5)
                self.view?.presentScene(dexScene, transition: transition)
            } else {
                gameReady()
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if lastUpdatedTime == nil {
            lastUpdatedTime = currentTime
            return
        }
        
        let timeInterval = currentTime - lastUpdatedTime
        lastUpdatedTime = currentTime
    
        if (gameState == .Ready || gameState == .Over) {
            return
        }
        
        let movedDistance = timeInterval * Double(eggie.currentSpeed)
        updateDistance(movedDistance)
        eggie.balance()
        shiftPlatforms(movedDistance)
        shiftCollectables(movedDistance)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (gameState == .Over) {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.scene {
            gameOver()
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.platform {
            if eggie.state == .Jumping {
                eggie.state = .Running
            }
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.collectable {
            let collectable: Collectable
            if contact.bodyA.categoryBitMask == BitMaskCategory.collectable {
                collectable = contact.bodyA.node as! Collectable
            } else {
                collectable = contact.bodyB.node as! Collectable
            }
            
            collectable.hidden = true
            
            if collectable.type == .Ingredient {
                ingredientBar.addIngredient(collectable.ingredient!)
            } else {
                flavourBar.addCondiment(collectable.condiment!)
            }
        }
    }
    
    private func initializePhysicsProperties() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, -9.8)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody!.categoryBitMask = BitMaskCategory.scene
        physicsBody!.contactTestBitMask = BitMaskCategory.hero
    }
    
    private func initializeDistanceLabel() {
        distanceLabel = SKLabelNode(fontNamed: GlobalConstants.fontName)
        distanceLabel.fontSize = GameScene.HEADER_FONT_SIZE
        distanceLabel.text = String(format: GameScene.DISTANCE_LABEL_TEXT, 0)
        distanceLabel.position = CGPoint(x: CGRectGetWidth(distanceLabel.frame), y: CGRectGetHeight(frame) - CGRectGetHeight(distanceLabel.frame))
        addChild(distanceLabel)
    }
    
    private func initializePlatform() {
        platformFactory = PlatformFactory()
        platforms = [Platform]()
        
        let pf = platformFactory.nextPlatform()
        pf.position.x = 0
        pf.position.y = 0
        platforms.append(pf)
        addChild(pf)
    }
    
    private func initialzieCollectable() {
        collectableFactory = CollectableFactory()
        collectables = [Collectable]()
        
        let collectable = collectableFactory.nextColletable()
        collectable.position.x = GameScene.FIRST_COLLECTABLE_POSITION_X
        collectable.position.y = platforms.last!.height + collectable.frame.size.height / 2 + GameScene.DISTANCE_PLATFORM_AND_COLLECTABLE
        collectables.append(collectable)
        addChild(collectable)
    }
    
    private func initializeEggie() {
        eggie = Eggie(startPosition: CGPoint(x: GameScene.EGGIE_X_POSITION, y: CGRectGetMidY(frame)))
        addChild(eggie)
    }
    
    private func initializeCollectableBars() {
        ingredientBar = IngredientBar()
        ingredientBar.position = CGPointMake(45, self.frame.height-45)
        addChild(ingredientBar)
        
        // to decide the position of flavour bar here
        flavourBar = FlavourBar()
        flavourBar.position = CGPointMake(90, self.frame.height-90)
        addChild(flavourBar)
    }
    
    private func updateDistance(movedDistance: Double) {
        distance += Int(movedDistance)
        distanceLabel.text = String(format: GameScene.DISTANCE_LABEL_TEXT, distance)
    }
    
    private func gameReady() {
        removeAllChildren()
        changeBackground(GameScene.BACKGROUND_IMAGE_NAME)
        initializeDistanceLabel()
        initializePlatform()
        initialzieCollectable()
        initializeEggie()
        initializeCollectableBars()
        gameState = .Ready
    }
    
    private func gameStart() {
        eggie.state = .Running
        gameState = .Playing
    }
    
    private func gameOver() {
        eggie.state = .Dying
        gameState = .Over
        
        //dummy dish, you'll just need to pass Huang Yue the real cooker
        let dish = DishDataController.singleton.getResultDish(Cooker.Drop, condiments: flavourBar.condimentDictionary, ingredients: ingredientBar.ingredients)
        
        //show ending layer, you'll just need to pass me the real cooker
        endingLayer = EndingLayer(usedCooker: Cooker.Drop, generatedDish: dish)
        endingLayer!.zPosition = 100
        endingLayer!.position = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
        addChild(endingLayer!)
    }
    
    private func shiftPlatforms(distance: Double) {
        let leftMostPlatform = platforms.first!
        let rightMostPlatform = platforms.last!
        let rightMostPlatformRightEnd = rightMostPlatform.position.x + rightMostPlatform.width + rightMostPlatform.followingGapWidth
        
        if rightMostPlatformRightEnd < UIScreen.mainScreen().bounds.width {
            let pf = platformFactory.nextPlatform()
            pf.position.x = rightMostPlatformRightEnd
            pf.position.y = 0
            platforms.append(pf)
            addChild(pf)
        }
        
        if leftMostPlatform.position.x + leftMostPlatform.width + leftMostPlatform.followingGapWidth < 0 {
            platforms.removeFirst()
            leftMostPlatform.removeFromParent()
        }
        
        for platform in platforms {
            platform.position.x -= CGFloat(distance)
        }
    }
    
    private func shiftCollectables(distance: Double) {
        let leftMostCollectable = collectables.first!
        let rightMostCollectable = collectables.last!
        let rightMostCollectableRightEnd = rightMostCollectable.position.x + rightMostCollectable.frame.size.width / 2 + rightMostCollectable.followingGapSize
        
        if rightMostCollectableRightEnd < UIScreen.mainScreen().bounds.width {
            let collectable = collectableFactory.nextColletable()
            collectable.position.x = rightMostCollectableRightEnd + collectable.frame.size.width / 2
            collectable.position.y = platforms.last!.height + collectable.frame.size.height / 2 + GameScene.DISTANCE_PLATFORM_AND_COLLECTABLE
            collectables.append(collectable)
            addChild(collectable)
        }
        
        if leftMostCollectable.position.x + leftMostCollectable.size.width / 2 + leftMostCollectable.followingGapSize < 0 {
            collectables.removeFirst()
            leftMostCollectable.removeFromParent()
        }
        
        for collectable in collectables {
            collectable.position.x -= CGFloat(distance)
        }
    }
}
