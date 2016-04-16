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
    private static let PAUSE_BUTTON_IMAGE_NAME = "button-pause"
    private static let PAUSE_BUTTON_SIZE = CGSizeMake(100, 100)
    private static let PAUSE_BUTTON_TOP_OFFSET: CGFloat = 50
    private static let PAUSE_BUTTON_RIGHT_OFFSET: CGFloat = 50
    private static let DISTANCE_LABEL_TEXT = "Distance: %dm"
    private static let HEADER_FONT_SIZE: CGFloat = 30
    private static let EGGIE_X_POSITION: CGFloat = 200
    private static let FIRST_COLLECTABLE_POSITION_X: CGFloat = 400
    private static let DISTANCE_PLATFORM_AND_COLLECTABLE: CGFloat = 200
    private static let OBSTACLE_RATE = 0.2
    private static let BUFFER_DISTANCE = 400.0
    private static let INGREDIENT_BAR_OFFSET: CGFloat = 15
    private static let FLAVOUR_BAR_OFFSET: CGFloat = 100
    private static let LEFT_FRAME_OFFSET: CGFloat = 400
    private static let TOP_FRAME_OFFSET: CGFloat = 400
    private static let GRAVITY = CGVectorMake(0, -20)
    private static let COLLECTABLE_SIZE = CGSizeMake(80, 80)
    private static let OVERLAY_Z_POSITION: CGFloat = 100
    
    private static let SE_COLLECT = SKAction.playSoundFileNamed("collect-sound.mp3", waitForCompletion: false)
    private static let SE_JUMP = SKAction.playSoundFileNamed("jump-sound.mp3", waitForCompletion: false)
    private static let SE_OBSTACLES: [Cooker: SKAction] = [.Drop: "drop-sound.mp3", .Oven: "oven-sound.mp3", .Pot: "pot-sound.mp3"].map({ SKAction.playSoundFileNamed($0, waitForCompletion: false) })
    
    private enum GameState {
        case Ready, Playing, Over, Paused
    }
    
    private var eggie: Eggie!
    private var platformFactory: PlatformFactory!
    private var collectableFactory: CollectableFactory!
    private var obstacleFactory: ObstacleFactory!
    private var ingredientBar: IngredientBar!
    private var flavourBar: FlavourBar!
    private var gameState: GameState = .Ready
    private var distanceLabel: SKLabelNode!
    private var distance = 0
    private var platforms: [Platform]!
    private var collectables: [Collectable]!
    private var obstacles: [Obstacle]!
    private var lastUpdatedTime: CFTimeInterval!
    private var endingLayer: EndingLayer?
    private var pauseButton: SKSpriteNode!
    private var pausedLayer: PausedLayer?

    override func didMoveToView(view: SKView) {
        initializePhysicsProperties()
        gameReady()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        if gameState == .Ready {
            gameStart()
        } else if gameState == .Playing {
            let touchLocation = touch.locationInNode(self)
            
            if pauseButton.containsPoint(touchLocation) {
                pause()
            } else if eggie.canJump {
                self.runAction(GameScene.SE_JUMP)
                eggie.state = .Jumping
            }
        } else if gameState == .Over && endingLayer != nil {
            let touchLocation = touch.locationInNode(endingLayer!)
            
            if endingLayer!.eggdexButton.containsPoint(touchLocation) {
                let dexScene = DexScene(size: self.size)
                let transition = SKTransition.flipHorizontalWithDuration(0.5)
                self.view?.presentScene(dexScene, transition: transition)
            } else if endingLayer!.playButton.containsPoint(touchLocation) {
                gameReady()
            }
        } else if gameState == .Paused && pausedLayer != nil {
            let touchLocation = touch.locationInNode(pausedLayer!)
            
            if pausedLayer!.unpauseButton.containsPoint(touchLocation) {
                unpause()
            } else if pausedLayer!.backToMenuButton.containsPoint(touchLocation) {
                let menuScene = MenuScene.singleton
                self.view?.presentScene(menuScene!, transition: MenuScene.BACK_TRANSITION)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (gameState == .Playing || gameState == .Ready) {
            if lastUpdatedTime == nil {
                lastUpdatedTime = currentTime
                return
            }
            
            let timeInterval = currentTime - lastUpdatedTime
            lastUpdatedTime = currentTime
            
            let movedDistance = timeInterval * Double(eggie.currentSpeed)
            updateDistance(movedDistance)
            eggie.balance()
            flavourBarFollow()
            shiftPlatforms(movedDistance)
            shiftCollectables(movedDistance)
            shiftObstacles(movedDistance)
        }
    }
    
    private func flavourBarFollow() {
        flavourBar.position = CGPoint(x: eggie.position.x, y: eggie.position.y + GameScene.FLAVOUR_BAR_OFFSET)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if gameState != .Playing {
            return
        }
        
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.scene {
            gameOver(.Drop)
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
                animateMovingIngredient(collectable.ingredient!, originalPosition: collectable.position)
                //ingredientBar.addIngredient(collectable.ingredient!)
            } else {
                flavourBar.addCondiment(collectable.condiment!)
            }
            
            self.runAction(GameScene.SE_COLLECT)
            
            if let particles = SKEmitterNode(fileNamed: "Collection.sks") {
                particles.position = contact.contactPoint
                collectable.emitter = particles
                addChild(particles)
            }
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.obstacle {
            var obstacle: Obstacle
            if contact.bodyA.categoryBitMask == BitMaskCategory.obstacle {
                obstacle = contact.bodyA.node!.parent as! Obstacle
            } else {
                obstacle = contact.bodyB.node!.parent as! Obstacle
            }
            
            if obstacle.isDeadly(contact.contactNormal, point: contact.contactPoint) {
                eggie.hidden = true
                obstacle.animateClose()
                gameOver(obstacle.cookerType)
            } else {
                obstacle.isPassed = true
                eggie.state = .Running
            }
        }
    }
    
    private func initializePhysicsProperties() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = GameScene.GRAVITY
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: frame.minX - GameScene.LEFT_FRAME_OFFSET, y: frame.minY, width: frame.width + GameScene.LEFT_FRAME_OFFSET, height: frame.height + GameScene.TOP_FRAME_OFFSET))
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
    
    private func initializeObstacle() {
        obstacleFactory = ObstacleFactory()
        obstacles = [Obstacle]()
    }
    
    private func initializePlatform() {
        platformFactory = PlatformFactory()
        platforms = [Platform]()
        appendNewPlatform(0)
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
        ingredientBar.position = CGPointMake(GameScene.INGREDIENT_BAR_OFFSET, self.frame.height-ingredientBar.frame.height/2 - GameScene.INGREDIENT_BAR_OFFSET)
        addChild(ingredientBar)
        
        flavourBar = FlavourBar()
        flavourBarFollow()
        addChild(flavourBar)
    }
    
    private func initializePauseButton() {
        pauseButton = SKSpriteNode(imageNamed: GameScene.PAUSE_BUTTON_IMAGE_NAME)
        pauseButton.size = GameScene.PAUSE_BUTTON_SIZE
        pauseButton.anchorPoint = CGPointMake(1, 1)
        pauseButton.position = CGPointMake(scene!.frame.maxX - GameScene.PAUSE_BUTTON_RIGHT_OFFSET, scene!.frame.maxY - GameScene.PAUSE_BUTTON_TOP_OFFSET)
        addChild(pauseButton)
    }
    
    private func updateDistance(movedDistance: Double) {
        distance += Int(movedDistance)
        distanceLabel.text = String(format: GameScene.DISTANCE_LABEL_TEXT, distance)
    }
    
    private func gameReady() {
        removeAllChildren()
        changeBackground(GameScene.BACKGROUND_IMAGE_NAME)
        initializeDistanceLabel()
        initializeObstacle()
        initializePlatform()
        initialzieCollectable()
        initializeEggie()
        initializeCollectableBars()
        initializePauseButton()
        
        if let particles = SKEmitterNode(fileNamed: "Snow.sks") {
            particles.position = CGPointMake(self.frame.midX, self.frame.maxY)
            particles.particlePositionRange.dx = self.frame.width
            addChild(particles)
        }
        
        distance = 0
        gameState = .Ready
    }
    
    private func gameStart() {
        eggie.state = .Running
        gameState = .Playing
    }
    
    private func gameOver(wayOfDie: Cooker) {
        eggie.state = .Dying
        gameState = .Over
        
        flavourBar.removeFromParent()
        
        let dish = DishDataController.singleton.getResultDish(wayOfDie, condiments: flavourBar.condimentDictionary, ingredients: ingredientBar.ingredients)
        
        endingLayer = EndingLayer(usedCooker: wayOfDie, generatedDish: dish)
        endingLayer!.zPosition = GameScene.OVERLAY_Z_POSITION
        endingLayer!.position = CGPointMake(frame.midX, frame.midY)
        addChild(endingLayer!)
        
        if let action = GameScene.SE_OBSTACLES[wayOfDie] {
            self.runAction(action)
        }
    }
    
    private func shiftPlatforms(distance: Double) {
        let rightMostPlatform = platforms.last!
        let rightMostPlatformRightEnd = rightMostPlatform.position.x + rightMostPlatform.width + rightMostPlatform.followingGapWidth
        
        if rightMostPlatformRightEnd < UIScreen.mainScreen().bounds.width {
            appendNewPlatform(rightMostPlatformRightEnd)
        }
        
        for platform in platforms {
            if platform.position.x + platform.width + platform.followingGapWidth < 0 {
                platforms.removeFirst()
                platform.removeFromParent()
            } else {
                platform.position.x -= CGFloat(distance)
            }
        }
    }
    
    private func shiftCollectables(distance: Double) {
        let rightMostCollectable = collectables.last!
        let rightMostCollectableRightEnd = rightMostCollectable.position.x + rightMostCollectable.frame.size.width / 2 + rightMostCollectable.followingGapSize
        
        if rightMostCollectableRightEnd < UIScreen.mainScreen().bounds.width {
            let collectable = collectableFactory.nextColletable()
            collectable.position.x = rightMostCollectableRightEnd + collectable.frame.size.width / 2
            collectable.position.y = platforms.last!.height + collectable.frame.size.height / 2 + GameScene.DISTANCE_PLATFORM_AND_COLLECTABLE
            collectables.append(collectable)
            addChild(collectable)
        }

        for collectable in collectables {
            if collectable.position.x + collectable.size.width / 2 + collectable.followingGapSize < 0 {
                collectables.removeFirst()
                collectable.removeFromParent()
            } else {
                collectable.position.x -= CGFloat(distance)
            }
        }
    }
    
    private func shiftObstacles(distance: Double) {
        for obstacle in obstacles {
            if obstacle.position.x + CGFloat(Obstacle.WIDTH) < 0 {
                obstacle.removeFromParent()
                obstacles.removeFirst()
            } else {
                obstacle.position.x -= CGFloat(distance)
            }
        }
    }
    
    private func appendNewPlatform(position: CGFloat) {
        let pf = platformFactory.nextPlatform()
        pf.position.x = position
        pf.position.y = 0
        platforms.append(pf)
        addChild(pf)
        
        var position = CGFloat(GameScene.BUFFER_DISTANCE)
        while position < pf.width - CGFloat(GameScene.BUFFER_DISTANCE) {
            if Double(arc4random()) / Double(UINT32_MAX) <= GameScene.OBSTACLE_RATE {
                let obstacle = obstacleFactory.nextObstacle()
                obstacle.position.y = pf.height + obstacle.heightPadding
                obstacle.position.x = pf.position.x + position
                obstacles.append(obstacle)
                addChild(obstacle)
                position += CGFloat(Obstacle.WIDTH + GameScene.BUFFER_DISTANCE)
            } else {
                position += CGFloat(GameScene.BUFFER_DISTANCE)
            }
        }
    }
    
    func animateMovingIngredient(ingredient: Ingredient, originalPosition: CGPoint) {
        let ingredientNode = SKSpriteNode(texture: ingredient.fineTexture, color: UIColor.clearColor(), size: GameScene.COLLECTABLE_SIZE)
        ingredientNode.position = originalPosition
        let newPosition = CGPointMake(ingredientBar.getNextGridX(ingredient) + GameScene.INGREDIENT_BAR_OFFSET, ingredientBar.position.y)
        let moveAction = SKAction.moveTo(newPosition, duration: 0.5)
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let actions = [moveAction, fadeOutAction]
        let actionGroup = SKAction.group(actions)
        addChild(ingredientNode)
        ingredientNode.runAction(actionGroup, completion: { () -> Void in
            self.ingredientBar.addIngredient(ingredient)
        })
    }
    
    private func pause() {
        if self.gameState == .Playing {
            self.physicsWorld.speed = 0
            self.gameState = .Paused
            eggie.pauseAtlas()
            pausedLayer = PausedLayer(frameSize: frame.size)
            pausedLayer!.zPosition = GameScene.OVERLAY_Z_POSITION
            pausedLayer!.position = CGPointMake(frame.midX, frame.midY)
            addChild(pausedLayer!)
        }
    }
    
    private func unpause() {
        if self.gameState == .Paused {
            pausedLayer!.removeFromParent()
            self.lastUpdatedTime = nil
            self.gameState = .Playing
            self.physicsWorld.speed = 1
            eggie.unpauseAtlas()
        }
    }
}
