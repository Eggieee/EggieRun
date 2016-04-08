//
//  EggieRunTests.swift
//  EggieRunTests
//
//  Created by CNA_Bld on 3/18/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import XCTest
@testable import EggieRun

class EggieRunTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGetResultDish() {
        XCTAssertEqual(DishDataController.singleton.getResultDish(.Drop, condiments: [:], ingredients: []).id, 0)
        
        XCTAssertEqual(DishDataController.singleton.getResultDish(.Pot, condiments: [:], ingredients: []).id, -1)
        
        XCTAssertEqual(DishDataController.singleton.getResultDish(.Pot, condiments: [.Salt: 1], ingredients: []).id, -4)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
