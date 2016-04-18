//
//  GameScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright (c) 2016 Eggieee. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    static var instance: GameScene?
    
    // Constants
    private static let BACKGROUND_IMAGE_NAME = "default-background"
    private static let PAUSE_BUTTON_IMAGE_NAME = "button-pause"
    private static let PAUSE_BUTTON_SIZE = CGSizeMake(100, 100)
    private static let PAUSE_BUTTON_TOP_OFFSET: CGFloat = 50
    private static let PAUSE_BUTTON_RIGHT_OFFSET: CGFloat = 50
    private static let DISTANCE_LABEL_TEXT = "Distance: %dm"
    private static let HEADER_FONT_SIZE: CGFloat = 30
    private static let EGGIE_X_POSITION: CGFloat = 200
    private static let DISTANCE_CLOSET_AND_COLLECTABLE: CGFloat = 200
    private static let DISTANCE_SHELF_AND_COLLECTABLE: CGFloat = 50
    private static let OBSTACLE_RATE_LOW = 0.2
    private static let OBSTACLE_RATE_HIGH = 0.7
    private static let COLLECTABLE_RATE = 0.3
    private static let BUFFER_DISTANCE = 400.0
    private static let COLLECTABLE_BUFFER_DISTANCE: CGFloat = 200
    private static let INGREDIENT_BAR_X_OFFSET: CGFloat = 15
    private static let INGREDIENT_BAR_Y_OFFSET: CGFloat = 33
    private static let PROGRESS_BAR_X_OFFSET: CGFloat = 15
    private static let PROGRESS_BAR_Y_OFFSET: CGFloat = 20
    private static let FLAVOUR_BAR_OFFSET: CGFloat = 100
    private static let LEFT_FRAME_OFFSET: CGFloat = 400
    private static let TOP_FRAME_OFFSET: CGFloat = 800
    private static let COLLECTABLE_SIZE = CGSizeMake(80, 80)
    private static let HUD_Z_POSITION: CGFloat = 50
    private static let OVERLAY_Z_POSITION: CGFloat = 100
    
    private static let SE_COLLECT = SKAction.playSoundFileNamed("collect-sound.mp3", waitForCompletion: false)
    private static let SE_JUMP = SKAction.playSoundFileNamed("jump-sound.mp3", waitForCompletion: false)
    private static let SE_OBSTACLES: [Cooker: SKAction] = [.Drop: "drop-sound.mp3", .Oven: "oven-sound.mp3", .Pot: "pot-sound.mp3", .Pan: "pan-sound.mp3"].map({ SKAction.playSoundFileNamed($0, waitForCompletion: false) })
    
    private enum GameState {
        case Ready, Playing, Over, Paused
    }
    
    private var eggie: Eggie!
    private var closetFactory: ClosetFactory!
    private var shelfFactory: ShelfFactory!
    private var collectableFactory: CollectableFactory!
    private var obstacleFactory: ObstacleFactory!
    private var ingredientBar: IngredientBar!
    private var flavourBar: FlavourBar!
    private var runningProgressBar: RunningProgressBar!
    private var gameState: GameState = .Ready
    private var distanceLabel: SKLabelNode!
    private var currentDistance = 0
    private var closets: [Closet]!
    private var shelves: [Shelf]!
    private var collectables: Set<Collectable>!
    private var obstacles: [Obstacle]!
    private var lastUpdatedTime: CFTimeInterval!
    private var endingLayer: EndingLayer?
    private var pauseButton: SKSpriteNode!
    private var pausedLayer: PausedLayer?
    private var milestones: [Milestone] = Milestone.ALL_VALUES
    private var tutorialLayer: TutorialLayer!
    private var nextMilestoneIndex = 0 {
        didSet {
            nextMilestone = milestones[nextMilestoneIndex]
        }
    }
    private var nextMilestone: Milestone?
    private var availableCookers = [Cooker]()
    private var obstacleRate: Double!
    private var isCookerIncreased = false

    override func didMoveToView(view: SKView) {
        GameScene.instance = self
        BGMPlayer.singleton.moveToStatus(.Game)
        
        initializePhysicsProperties()
        gameReady()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        if gameState == .Ready {
            let touchLocation = touch.locationInNode(tutorialLayer!)
            if tutorialLayer.nextPageNode.containsPoint(touchLocation) {
                if tutorialLayer.currPage < TutorialLayer.tutorials.count - 1 {
                    tutorialLayer.getNextTutorial()
                }
            } else if tutorialLayer.prevPageNode.containsPoint(touchLocation) {
                if tutorialLayer.currPage > 0 {
                    tutorialLayer.getPrevTutorial()
                }
            } else {
                gameStart()
                tutorialLayer.removeFromParent()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState == .Playing {
            let touch = touches.first!
            let touchLocation = touch.locationInNode(self)
            
            if pauseButton.containsPoint(touchLocation) {
                pause()
            } else if eggie.state == .Running {
                eggie.state = .Jumping_1
                self.runAction(GameScene.SE_JUMP)
            } else if eggie.state == .Jumping_1 {
                eggie.state = .Jumping_2
                self.runAction(GameScene.SE_JUMP)
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
            runningProgressBar.updateDistance(movedDistance)
            eggie.balance()
            flavourBarFollow()
            shiftShelf(movedDistance)
            shiftClosets(movedDistance)
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
            let impulse: CGVector
            if contact.bodyA.categoryBitMask == BitMaskCategory.platform {
                impulse = contact.contactNormal
            } else {
                impulse = CGVectorMake(-1 * contact.contactNormal.dx, -1 * contact.contactNormal.dy)
            }
            
            if impulse.dy > 0 {
                eggie.state = .Running
            }
        } else if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == BitMaskCategory.hero | BitMaskCategory.collectable {
            let collectable: Collectable
            if contact.bodyA.categoryBitMask == BitMaskCategory.collectable {
                collectable = contact.bodyA.node as! Collectable
            } else {
                collectable = contact.bodyB.node as! Collectable
            }
            
            let position = collectable.position
            collectable.hidden = true
            collectable.physicsBody?.categoryBitMask = 0
            collectable.physicsBody?.contactTestBitMask = 0
            
            self.runAction(GameScene.SE_COLLECT)
            
            if collectable.type == .Ingredient {
                animateMovingIngredient(collectable.ingredient!, originalPosition: collectable.position)
            } else {
                flavourBar.addCondiment(collectable.condiment!)
            }
            
            if let particles = SKEmitterNode(fileNamed: "Collection.sks") {
                particles.position = position
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
        physicsWorld.gravity = GlobalConstants.GRAVITY
        
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
        availableCookers = [Cooker]()
        obstacleRate = GameScene.OBSTACLE_RATE_LOW
        obstacleFactory = ObstacleFactory()
        obstacles = [Obstacle]()
    }
    
    private func initializeCloset() {
        closetFactory = ClosetFactory()
        closets = [Closet]()
        appendNewCloset(0)
    }
    
    private func initializeShelf() {
        shelfFactory = ShelfFactory()
        shelves = [Shelf]()
    }
    
    private func initialzieCollectable() {
        collectableFactory = CollectableFactory()
        collectables = Set<Collectable>()
    }
    
    private func initializeEggie() {
        eggie = Eggie(startPosition: CGPoint(x: GameScene.EGGIE_X_POSITION, y: CGRectGetMidY(frame)))
        addChild(eggie)
    }
    
    private func initializeCollectableBars() {
        ingredientBar = IngredientBar()
        ingredientBar.position = CGPointMake(GameScene.INGREDIENT_BAR_X_OFFSET, self.frame.height-ingredientBar.frame.height/2 - GameScene.INGREDIENT_BAR_Y_OFFSET)
        ingredientBar.zPosition = GameScene.HUD_Z_POSITION
        addChild(ingredientBar)
        
        flavourBar = FlavourBar()
        flavourBar.zPosition = GameScene.HUD_Z_POSITION
        flavourBarFollow()
        addChild(flavourBar)
    }
    
    private func initializeRunningProgressBar() {
        let barLength = frame.width - 2 * GameScene.PROGRESS_BAR_X_OFFSET
        runningProgressBar = RunningProgressBar(length: barLength, allMilestones: milestones)
        runningProgressBar.position = CGPointMake(GameScene.PROGRESS_BAR_X_OFFSET, self.frame.height - GameScene.PROGRESS_BAR_Y_OFFSET)
        addChild(runningProgressBar)
    }

    private func initializePauseButton() {
        pauseButton = SKSpriteNode(imageNamed: GameScene.PAUSE_BUTTON_IMAGE_NAME)
        pauseButton.size = GameScene.PAUSE_BUTTON_SIZE
        pauseButton.anchorPoint = CGPointMake(1, 1)
        pauseButton.position = CGPointMake(scene!.frame.maxX - GameScene.PAUSE_BUTTON_RIGHT_OFFSET, scene!.frame.maxY - GameScene.PAUSE_BUTTON_TOP_OFFSET)
        pauseButton.hidden = true
        addChild(pauseButton)
    }
    
    private func initializeMilestone() {
        nextMilestoneIndex = 0
    }
    
    private func initializeTutorial() {
        tutorialLayer = TutorialLayer(frameWidth: self.frame.width, frameHeight: self.frame.height)
        tutorialLayer.zPosition = GameScene.OVERLAY_Z_POSITION
        addChild(tutorialLayer)
    }
    
    private func updateDistance(movedDistance: Double) {
        currentDistance += Int(movedDistance)
        if (currentDistance >= nextMilestone!.requiredDistance) {
            activateCurrentMilestone()
        }
        distanceLabel.text = String(format: GameScene.DISTANCE_LABEL_TEXT, currentDistance)
    }
    
    
    private func gameReady() {
        removeAllChildren()
        changeBackground(GameScene.BACKGROUND_IMAGE_NAME)
        initializeDistanceLabel()
        initializeObstacle()
        initialzieCollectable()
        initializeCloset()
        initializeShelf()
        initializeEggie()
        initializeCollectableBars()
        initializeRunningProgressBar()
        initializePauseButton()
        initializeMilestone()
        initializeTutorial()
        
        currentDistance = 0
        gameState = .Ready
    }
    
    private func gameStart() {
        pauseButton.hidden = false
        eggie.state = .Running
        gameState = .Playing
    }
    
    private func gameOver(wayOfDie: Cooker) {
        eggie.state = .Dying
        gameState = .Over
        
        if let action = GameScene.SE_OBSTACLES[wayOfDie] {
            self.runAction(action)
        }
        
        flavourBar.removeFromParent()
        
        let (dish, isNew) = DishDataController.singleton.getResultDish(wayOfDie, condiments: flavourBar.condimentDictionary, ingredients: ingredientBar.ingredients)
        
        endingLayer = EndingLayer(usedCooker: wayOfDie, generatedDish: dish, isNew: isNew)
        endingLayer!.zPosition = GameScene.OVERLAY_Z_POSITION
        endingLayer!.position = CGPointMake(frame.midX, frame.midY)
        addChild(endingLayer!)
    }
    
    private func shiftClosets(distance: Double) {
        let rightMostCloset = closets.last!
        let rightMostClosetRightEnd = rightMostCloset.position.x + rightMostCloset.width + Closet.GAP_SIZE
        
        if rightMostClosetRightEnd < UIScreen.mainScreen().bounds.width {
            appendNewCloset(rightMostClosetRightEnd)
        }
        
        for closet in closets {
            if closet.position.x + closet.width + Closet.GAP_SIZE < 0 {
                closets.removeFirst()
                closet.removeFromParent()
            } else {
                closet.position.x -= CGFloat(distance)
            }
        }
    }
    
    private func shiftShelf(distance: Double) {
        if shelves.isEmpty {
            return
        }
        
        let rightMostShelf = shelves.last!
        let rightMostShelfRightEnd = rightMostShelf.position.x + rightMostShelf.width + rightMostShelf.followingGapSize
        
        if rightMostShelfRightEnd < UIScreen.mainScreen().bounds.width {
            appendNewShelf(rightMostShelfRightEnd)
        }
        
        for shelf in shelves {
            if shelf.position.x + shelf.width + shelf.followingGapSize < 0 {
                shelves.removeFirst()
                shelf.removeFromParent()
            } else {
                shelf.position.x -= CGFloat(distance)
            }
        }
    }
    
    private func shiftCollectables(distance: Double) {
        for collectable in collectables {
            if collectable.position.x + collectable.size.width / 2 < 0 {
                collectable.removeFromParent()
                collectables.remove(collectable)
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
    
    private func appendNewCloset(position: CGFloat) {
        let closet = closetFactory.nextPlatform()
        closet.position.x = position
        closet.position.y = Closet.BASELINE_HEIGHTS
        closets.append(closet)
        addChild(closet)
        
        if !availableCookers.isEmpty {
            var position = CGFloat(GameScene.BUFFER_DISTANCE)
            while position < closet.width - CGFloat(GameScene.BUFFER_DISTANCE) {
                if Double(arc4random()) / Double(UINT32_MAX) <= obstacleRate {
                    let obstacle = obstacleFactory.nextObstacle(availableCookers)
                    obstacle.position.y = Closet.BASELINE_HEIGHTS + Closet.HEIGHT + obstacle.heightPadding
                    obstacle.position.x = closet.position.x + position
                    obstacles.append(obstacle)
                    addChild(obstacle)
                    position += CGFloat(Obstacle.WIDTH + GameScene.BUFFER_DISTANCE)
                } else {
                    position += CGFloat(GameScene.BUFFER_DISTANCE)
                }
            }
        }

        var collectablePostiom = GameScene.COLLECTABLE_BUFFER_DISTANCE
        while collectablePostiom < closet.width - GameScene.COLLECTABLE_BUFFER_DISTANCE {
            if Double(arc4random()) / Double(UINT32_MAX) <= GameScene.COLLECTABLE_RATE {
                let collectable = collectableFactory.nextColletable(currentDistance)
                collectable.position.y = Closet.BASELINE_HEIGHTS + Closet.HEIGHT + Collectable.SIZE.height / 2 + GameScene.DISTANCE_CLOSET_AND_COLLECTABLE
                collectable.position.x = closet.position.x + collectablePostiom
                collectables.insert(collectable)
                addChild(collectable)
                collectablePostiom += Collectable.SIZE.width + GameScene.COLLECTABLE_BUFFER_DISTANCE
            } else {
                collectablePostiom += GameScene.COLLECTABLE_BUFFER_DISTANCE
            }
        }
    }
    
    private func appendNewShelf(position: CGFloat) {
        let shelf = shelfFactory.nextPlatform()
        shelf.position.x = position
        shelf.position.y = Shelf.BASELINE_HEIGHTS
        shelves.append(shelf)
        addChild(shelf)
        
        var position = GameScene.COLLECTABLE_BUFFER_DISTANCE
        while position < shelf.width - GameScene.COLLECTABLE_BUFFER_DISTANCE {
            if Double(arc4random()) / Double(UINT32_MAX) <= GameScene.COLLECTABLE_RATE {
                let collectable = collectableFactory.nextColletable(currentDistance)
                collectable.position.y = Shelf.BASELINE_HEIGHTS + Shelf.HEIGHT + Collectable.SIZE.height / 2 + GameScene.DISTANCE_SHELF_AND_COLLECTABLE
                collectable.position.x = shelf.position.x + position
                collectables.insert(collectable)
                addChild(collectable)
                position += Collectable.SIZE.width + GameScene.COLLECTABLE_BUFFER_DISTANCE
            } else {
                position += GameScene.COLLECTABLE_BUFFER_DISTANCE
            }
        }
    }
    
    func animateMovingIngredient(ingredient: Ingredient, originalPosition: CGPoint) {
        let ingredientNode = SKSpriteNode(texture: ingredient.fineTexture, color: UIColor.clearColor(), size: GameScene.COLLECTABLE_SIZE)
        ingredientNode.position = originalPosition
        let newPosition = CGPointMake(ingredientBar.getNextGridX(ingredient) + GameScene.INGREDIENT_BAR_X_OFFSET, ingredientBar.position.y)
        let moveAction = SKAction.moveTo(newPosition, duration: 0.5)
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let actions = [moveAction, fadeOutAction]
        let actionGroup = SKAction.group(actions)
        addChild(ingredientNode)
        ingredientNode.runAction(actionGroup, completion: { () -> Void in
            self.ingredientBar.addIngredient(ingredient)
        })
    }
    
    override func willMoveFromView(view: SKView) {
        removeAllChildren()
        GameScene.instance = nil
    }
    
    func pause() {
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
    
    private func activateCurrentMilestone() {
        if(nextMilestoneIndex < milestones.count - 1) {
            runningProgressBar.activateCurrentMilestone()
            activateMilestoneEvent()
            nextMilestoneIndex += 1
        }
    }
    
    private func activateMilestoneEvent() {
        switch nextMilestone! {
        case .PresentPot:
            availableCookers.append(.Pot)
        case .PresentShelf:
            appendNewShelf(UIScreen.mainScreen().bounds.width)
        case .PresentOven:
            availableCookers.append(.Oven)
        case .ChallengeDarkness:
            print("dark!")
        case .PresentPan:
            availableCookers.append(.Pan)
        case .ChallengeQuake:
            print("earth quake!")
        case .IncreasePot:
            obstacleRate = GameScene.OBSTACLE_RATE_HIGH
        case .EndOyakodon:
            print("oyakodon!")
        }
    }
}
