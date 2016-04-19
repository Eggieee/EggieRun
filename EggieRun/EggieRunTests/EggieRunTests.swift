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
        DishDataController.singleton.clearActivatedDishes()
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGetResultDish() {
        XCTAssertEqual(DishDataController.singleton.getResultDish(.Drop, condiments: [:], ingredients: []).0.id, 0)
        
        XCTAssertEqual(DishDataController.singleton.getResultDish(.Pot, condiments: [:], ingredients: []).0.id, -1)
        
//        XCTAssertEqual(DishDataController.singleton.getResultDish(.Pot, condiments: [.Sugar: 1], ingredients: []).0.id, -4)
    }
    
}
