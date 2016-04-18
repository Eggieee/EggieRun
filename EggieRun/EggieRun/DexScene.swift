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
    private static let TITLE_FONT = "Chalkduster"
    private static let TITLE_SIZE = CGFloat(40)
    private static let TITLE_TOP_PADDING = CGFloat(20)
    
    private static let BACK_BUTTON_SIZE = CGFloat(80)
    private static let FLIP_BUTTON_WIDTH = CGFloat(90)
    private static let FLIP_BUTTON_HEIGHT = CGFloat(60)
    private static let NEXT_BUTTON_X = CGFloat(500)
    private static let PREV_BUTTON_X = CGFloat(100)
    private static let FLIP_BUTTON_Y = CGFloat(80)

    
    private static let DISH_FIRST_PAGE = Array(DishDataController.singleton.dishes[0..<12])
    private static let DISH_SECOND_PAGE = Array(DishDataController.singleton.dishes[12..<21])
    
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

    
    override func didMoveToView(view: SKView) {
        BGMPlayer.singleton.moveToStatus(.Dex)
        
        let titleLabel = SKLabelNode(fontNamed: DexScene.TITLE_FONT)
        titleLabel.text = DexScene.TITLE_TEXT
        titleLabel.fontSize = DexScene.TITLE_SIZE
        titleLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - DexScene.TITLE_SIZE - DexScene.TITLE_TOP_PADDING)
        self.addChild(titleLabel)
        
        buttonBack = SKSpriteNode(imageNamed: "button-return")
        buttonBack.size = CGSize(width: DexScene.BACK_BUTTON_SIZE, height: DexScene.BACK_BUTTON_SIZE)
        buttonBack.position = CGPoint(x: DexScene.BACK_BUTTON_SIZE, y: self.frame.height - DexScene.BACK_BUTTON_SIZE / 2)
        self.addChild(buttonBack)
        
        gridNode = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width, dishList: DexScene.DISH_FIRST_PAGE)
        self.addChild(gridNode)
        
        createDetailNode()
        createFlipPageNode()
        createSpecialEffect()
        
        if GlobalConstants.IS_DEMO {
            createNodeForDemo()
        }
    }
    
    private func createNodeForDemo() {
        activateAll = SKSpriteNode(color: UIColor.darkGrayColor(), size: CGSize(width: 40, height: 40))
        activateAll.position = CGPoint(x: self.frame.width - DexScene.TITLE_TOP_PADDING, y: self.frame.height - DexScene.TITLE_TOP_PADDING)
        
    }
    
    
    // create next and previous flipping page buttons
    private func createFlipPageNode() {
        nextPageNode = SKSpriteNode(imageNamed: "arrow-right")
        nextPageNode.position = CGPoint(x: DexScene.NEXT_BUTTON_X, y: DexScene.FLIP_BUTTON_Y)
        nextPageNode.zPosition = 2
        nextPageNode.size = CGSize(width: DexScene.FLIP_BUTTON_WIDTH, height: DexScene.FLIP_BUTTON_HEIGHT)
        addChild(nextPageNode)
        
        prevPageNode = SKSpriteNode(imageNamed: "arrow-left")
        prevPageNode.position = CGPoint(x: DexScene.PREV_BUTTON_X, y: DexScene.FLIP_BUTTON_Y)
        prevPageNode.zPosition = 2
        prevPageNode.size = CGSize(width: DexScene.FLIP_BUTTON_WIDTH, height: DexScene.FLIP_BUTTON_HEIGHT)
        prevPageNode.alpha = 0.5
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
            nextPageNode.alpha = 0.5
            prevPageNode.alpha = 1
        }
        
        if prevPageNode.containsPoint(touchLocation) {
            gridNode.removeFromParent()
            gridNode = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width, dishList: DexScene.DISH_FIRST_PAGE)
            self.addChild(gridNode)
            nextPageNode.alpha = 1
            prevPageNode.alpha = 0.5
        }
        
        // click on dishes
        let touchLocationInGrid = touch.locationInNode(gridNode)
        for dishNode in gridNode.dishNodes {
            if dishNode.containsPoint(touchLocationInGrid) {
                gridNode.moveEmitter(dishNode)
                detailNode.setDish(dishNode.dish, activated: dishNode.activated)
                break
            }
        }
        
        // click on activate all
        if activateAll.containsPoint(touchLocation) {
            DishDataController.singleton.forceActivateAllDishes()
            gridNode.removeFromParent()
            gridNode = DexGridNode(sceneHeight: self.frame.height, sceneWidth: self.frame.width, dishList: DexScene.DISH_FIRST_PAGE)
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
