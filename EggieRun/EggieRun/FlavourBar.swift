//
//  FlavourBar.swift
//  EggieRun
//
//  Created by  light on 2016/03/31.
//  Copyright © 2016年 Eggieee. All rights reserved.
//

import SpriteKit

class FlavourBar: SKSpriteNode {
    private static let BAR_LENGTH = CGFloat(100)
    private static let BAR_HEIGHT = CGFloat(20)
    
    private var sugar: Float = 0
    private var salt: Float = 0
    private var chili: Float = 0
    
    private var condimentCount: Float {
        get {
            return sugar + salt + chili
        }
    }
    
    init() {
        super.init(texture: nil, color: UIColor.grayColor(), size: CGSizeMake(FlavourBar.BAR_LENGTH, FlavourBar.BAR_HEIGHT))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCondiment(newCondiment: Condiment) {
        switch newCondiment {
        case .Salt:
            salt++
        case .Sugar:
            sugar++
        case .Chili:
            chili++
        }
    }
    
    func getSingleFlavourPercentage(condiment: Condiment) -> Float {
        switch condiment {
        case .Salt:
            return salt/condimentCount
        case .Sugar:
            return sugar/condimentCount
        case .Chili:
            return chili/condimentCount
        }
    }
    
    func getSingleFlavourLength(condiment: Condiment) -> CGFloat {
        switch condiment {
        case .Salt:
            return CGFloat(getSingleFlavourPercentage(Condiment.Salt)) * FlavourBar.BAR_LENGTH
        case .Sugar:
            return CGFloat(getSingleFlavourPercentage(Condiment.Sugar)) * FlavourBar.BAR_LENGTH
        case .Chili:
            return CGFloat(getSingleFlavourPercentage(Condiment.Chili)) * FlavourBar.BAR_LENGTH
        }
    }
    
    func getSingleBarX(condiment: Condiment) -> CGFloat {
        switch condiment {
        case .Salt:
            return 0
        case .Sugar:
            return getSingleFlavourLength(Condiment.Salt)
        case .Chili:
            return getSingleFlavourLength(Condiment.Salt) + getSingleFlavourLength(Condiment.Sugar)
        }
    }
    
    private func updateBar() {
        
    }

}