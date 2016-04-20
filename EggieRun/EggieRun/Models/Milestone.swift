//
//  Milestone.swift
//  EggieRun
//
//  Created by  light on 4/18/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

enum Milestone: Int {
    case PresentPot = 0, PresentShelf = 1, PresentOven = 2, ChallengeDarkness = 3, PresentPan = 4, ChallengeQuake = 5, IncreasePot = 6, EndOyakodon = 7
    
    static let ALL_VALUES: [Milestone] = [.PresentPot, .PresentShelf, .PresentOven, .ChallengeDarkness, .PresentPan, .ChallengeQuake, .IncreasePot, .EndOyakodon]
    
    private static let DISTANCES = [10000, 20000, 30000, 40000, 50000, 65000, 85000, 100000]
    
    var requiredDistance: Int {
        return Milestone.DISTANCES[rawValue] / GlobalConstants.DEV_DISTANCE_DIVISOR
    }
    
    private var imageNamed: String {
        switch self {
        case .PresentPot:
            return "present-pot-milestone"
        case .PresentShelf:
            return "present-shelf-milestone"
        case .PresentOven:
            return "present-oven-milestone"
        case .ChallengeDarkness:
            return "challenge-darkness-milestone"
        case .PresentPan:
            return "present-pan-milestone"
        case .ChallengeQuake:
            return "challenge-quake-milestone"
        case .IncreasePot:
            return "increase-pot-milestone"
        case .EndOyakodon:
            return "end-oyakodon-milestone"
        }
    }
    
    private var monochromeImageNamed: String {
        return "mono-" + imageNamed
    }
    
    private var colouredImageNamed: String {
        return "colo-" + imageNamed
    }
    
    var monochromeTexture: SKTexture {
        return SKTexture(imageNamed: self.monochromeImageNamed)
    }
    
    var colouredTexture: SKTexture {
        return SKTexture(imageNamed: self.colouredImageNamed)
    }
}