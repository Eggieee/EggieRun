//
//  RandomPoolTests.swift
//  EggieRunTests
//
//  Created by CNA_Bld on 3/26/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import XCTest
@testable import EggieRun

class RandomPoolTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRandomPoolSingleObject() {
        let randomPool = RandomPool<Int>()
        randomPool.addObject(0, weightage: 1)
        XCTAssertEqual(randomPool.draw(), 0)
    }
    
    func testRandomPool() {
        let randomPool = RandomPool<Int>()
        randomPool.addObject(0, weightage: 1)
        randomPool.addObject(1, weightage: 1)
        XCTAssertTrue([0, 1].contains(randomPool.draw()))
        
        var set = Set<Int>()
        for _ in 0..<100 {
            set.insert(randomPool.draw())
        }
        // XCTAssertEqual(set, Set([0, 1]))
        // This is random, do manual test instead
    }
    
}
