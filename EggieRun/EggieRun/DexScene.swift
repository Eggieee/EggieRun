//
//  DexScene.swift
//  EggieRun
//
//  Created by CNA_Bld on 3/20/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class DexScene: SKScene {
    
    private static let TITLE_TEXT = "Éggdex"
    private static let TITLE_SIZE = CGFloat(40)
    private static let TITLE_TOP_PADDING = CGFloat(15)
    private static let TITLE_HEIGHT = CGFloat(80)
    
    private static let FLIP_BUTTON_WIDTH = CGFloat(90)
    private static let FLIP_BUTTON_HEIGHT = CGFloat(60)
    private static let NEXT_BUTTON_X = CGFloat(500)
    private static let PREV_BUTTON_X = CGFloat(100)
    private static let FLIP_BUTTON_Y = CGFloat(80)
    private static let DEMO_NODE_SIZE = CGFloat(50)
    private static let BACK_BUTTON_WIDTH = CGFloat(80)
    private static let BACK_BUTTON_HEIGHT = CGFloat(60)
    
    private static let TITLE_NODE_Z_POSITION = CGFloat(1)
    private static let OVERLAY_Z_POSITION = CGFloat(2)
    private static let SPECIAL_EFFECT_Z_POSITION = CGFloat(5)
    
    private static let BUTTON_ENABLED_ALPHA = CGFloat(1)
    private static let BUTTON_DISABLED_ALPHA = CGFloat(0.5)
    
    private static let TITLE_COLOR = UIColor(red: CGFloat(185/255.0), green: CGFloat(161/255.0), blue: CGFloat(249/255.0), alpha: 0.5)
    
    private static let DISH_FIRST_PAGE = Array(DishDataController.singleton.dishes[0..<12])
    private static let DISH_SECOND_PAGE = Array(DishDataController.singleton.dishes[12..<21])
    
    private static let TITLE_FONT = "Chalkduster"
    
    static let TOP_BAR_HEIGHT = CGFloat(80)
    static let GRID_WIDTH_RATIO = CGFloat(4.0 / 7)
    static let DETAIL_WIDTH_RATIO = CGFloat(3.0 / 7)
    
    static let UNACTIVATED_FILTER = CIFilter(name: "CIColorControls", withInputParameters: ["inputBrightness": -1])
    
    private var buttonBack: SKSpriteNode!
    private var gridNode: DexGridNode!
    private var detailNode: DexDetailNode!
    private var nextPageNode: SKSpriteNode!
    private var prevPageNode: SKSpriteNode!
    private var activateAll: SKSpriteNode!
    private var disableAll: SKSpriteNode!

    
    override func didMoveToView(view: SKView) {
        BGMPlayer.singleton.moveToStatus(.Dex)
        
        let topBarNode = SKSpriteNode(color: DexScene.TITLE_COLOR, size: CGSize(width: self.frame.width, height: DexScene.TITLE_HEIGHT))
        topBarNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height - DexScene.TITLE_HEIGHT/2)
        topBarNode.zPosition = DexScene.TITLE_NODE_Z_POSITION
        addChild(topBarNode)
        
        let titleLabel = SKLabelNode(fontNamed: DexScene.TITLE_FONT)
        titleLabel.text = DexScene.TITLE_TEXT
        titleLabel.fontSize = DexScene.TITLE_SIZE
        titleLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - DexScene.TITLE_SIZE - DexScene.TITLE_TOP_PADDING)
        titleLabel.zPosition = DexScene.OVERLAY_Z_POSITION
        addChild(titleLabel)
        
        buttonBack = SKSpriteNode(imageNamed: "button-return")
        buttonBack.size = CGSize(width: DexScene.BACK_BUTTON_WIDTH, height: DexScene.BACK_BUTTON_HEIGHT)
        buttonBack.position = CGPoint(x: DexScene.BACK_BUTTON_WIDTH, y: self.frame.height - DexScene.BACK_BUTTON_HEIGHT/2 - DexScene.TITLE_TOP_PADDING)
        buttonBack.zPosition = DexScene.OVERLAY_Z_POSITION
        addChild(buttonBack)
        
        changeBackground("eggdex-background")
        
        gridNode = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width, dishList: DexScene.DISH_FIRST_PAGE)
        addChild(gridNode)
        
        createDetailNode()
        createFlipPageNode()
        createSpecialEffect()
        
        if GlobalConstants.IS_DEMO {
            createNodeForDemo()
        }
    }
    
    // create disable and activate all dishes node for demostration
    private func createNodeForDemo() {
        activateAll = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: DexScene.DEMO_NODE_SIZE, height: DexScene.DEMO_NODE_SIZE))
        activateAll.position = CGPoint(x: self.frame.width - DexScene.TITLE_TOP_PADDING, y: self.frame.height - DexScene.TITLE_TOP_PADDING)
        disableAll = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: DexScene.DEMO_NODE_SIZE, height: DexScene.DEMO_NODE_SIZE))
        disableAll.position = CGPoint(x: self.frame.width - DexScene.TITLE_TOP_PADDING, y: DexScene.TITLE_TOP_PADDING)
    }
    
    
    // create next and previous flipping page buttons
    private func createFlipPageNode() {
        nextPageNode = SKSpriteNode(imageNamed: "arrow-right")
        nextPageNode.position = CGPoint(x: DexScene.NEXT_BUTTON_X, y: DexScene.FLIP_BUTTON_Y)
        nextPageNode.zPosition = DexScene.OVERLAY_Z_POSITION
        nextPageNode.size = CGSize(width: DexScene.FLIP_BUTTON_WIDTH, height: DexScene.FLIP_BUTTON_HEIGHT)
        addChild(nextPageNode)
        
        prevPageNode = SKSpriteNode(imageNamed: "arrow-left")
        prevPageNode.position = CGPoint(x: DexScene.PREV_BUTTON_X, y: DexScene.FLIP_BUTTON_Y)
        prevPageNode.zPosition = DexScene.OVERLAY_Z_POSITION
        prevPageNode.size = CGSize(width: DexScene.FLIP_BUTTON_WIDTH, height: DexScene.FLIP_BUTTON_HEIGHT)
        prevPageNode.alpha = DexScene.BUTTON_DISABLED_ALPHA
        addChild(prevPageNode)
    }
    
    // generate right side eggDex details
    private func createDetailNode() {
        detailNode = DexDetailNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width)
        self.addChild(detailNode)
    }
    
    // create special snowing effect
    private func createSpecialEffect() {
        if let particles = SKEmitterNode(fileNamed: "Snow.sks") {
            particles.position = CGPointMake(self.frame.midX, self.frame.maxY)
            particles.particlePositionRange.dx = self.frame.width
            particles.zPosition = DexScene.SPECIAL_EFFECT_Z_POSITION
            addChild(particles)
        }
    }
    
    
    // recognise touch behaviour on screen
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInNode(self)
        
        // back to menu
        if buttonBack.containsPoint(touchLocation) {
            let menuScene = MenuScene.singleton
            self.view?.presentScene(menuScene!, transition: MenuScene.BACK_TRANSITION)
        }
        
        // flipping page
        if nextPageNode.containsPoint(touchLocation) && nextPageNode.alpha==1 {
            gridNode.removeFromParent()
            gridNode = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width, dishList: DexScene.DISH_SECOND_PAGE)
            self.addChild(gridNode)
            nextPageNode.alpha = DexScene.BUTTON_DISABLED_ALPHA
            prevPageNode.alpha = DexScene.BUTTON_ENABLED_ALPHA
        }
        
        if prevPageNode.containsPoint(touchLocation) {
            gridNode.removeFromParent()
            gridNode = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width, dishList: DexScene.DISH_FIRST_PAGE)
            self.addChild(gridNode)
            nextPageNode.alpha = DexScene.BUTTON_ENABLED_ALPHA
            prevPageNode.alpha = DexScene.BUTTON_DISABLED_ALPHA
        }
        
        // click on individual dishes
        let touchLocationInGrid = touch.locationInNode(gridNode)
        for dishNode in gridNode.dishNodes {
            if dishNode.containsPoint(touchLocationInGrid) {
                gridNode.moveEmitter(dishNode)
                detailNode.setDish(dishNode.dish, activated: dishNode.activated)
                break
            }
        }
        
        // click on activate all button
        if activateAll.containsPoint(touchLocation) {
            DishDataController.singleton.forceActivateAllDishes()
        }
        
        // click on disable all button
        if disableAll.containsPoint(touchLocation) {
            DishDataController.singleton.clearActivatedDishes()
        }
    }
    
    override func willMoveFromView(view: SKView) {
        removeAllChildren()
        DishDataController.singleton.clearNewFlags()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
