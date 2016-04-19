//
//  ConstructableEngineTests.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/20/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import XCTest
@testable import EggieRun

class ConstructableEngineTests: XCTestCase {
    var constructableEngine: ConstructableEngine<TestConstructable>!
    
    override func setUp() {
        super.setUp()
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("TestConstructables", withExtension: "plist") {
            constructableEngine = ConstructableEngine<TestConstructable>(dataUrl: url, storageFileName: "test-constructables")
            constructableEngine.clearActivated()
            constructableEngine.clearNewFlags()
        } else {
            fatalError()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllConstructables() {
        XCTAssertEqual(constructableEngine.constructables.map({ $0.id }), [3, 0, 1, 2])
    }
    
    func testConstruct() {
        let constructResult = constructableEngine.getConstructResult([:])
        XCTAssertTrue([2, 3].contains(constructResult.0.id))
        XCTAssertTrue(constructResult.1)
        XCTAssertTrue(constructableEngine.isConstructableActivated(constructResult.0))
        XCTAssertTrue(constructableEngine.isConstructableNew(constructResult.0))
        XCTAssertEqual(constructableEngine.activatedConstructables.map({ $0.id }), [constructResult.0.id])
    }
    
    func testConstructLessThanZero() {
        let constructResult = constructableEngine.getConstructResult([0: 1])
        XCTAssertEqual(constructResult.0.id, 1)
        XCTAssertTrue(constructResult.1)
        XCTAssertTrue(constructableEngine.isConstructableActivated(constructResult.0))
        XCTAssertTrue(constructableEngine.isConstructableNew(constructResult.0))
    }
    
    func testClear() {
        let constructResult = constructableEngine.getConstructResult([:])
        XCTAssertTrue(constructableEngine.isConstructableActivated(constructResult.0))
        XCTAssertTrue(constructableEngine.isConstructableNew(constructResult.0))
        
        constructableEngine.clearNewFlags()
        XCTAssertTrue(constructableEngine.isConstructableActivated(constructResult.0))
        XCTAssertFalse(constructableEngine.isConstructableNew(constructResult.0))
        
        constructableEngine.clearActivated()
        XCTAssertFalse(constructableEngine.isConstructableActivated(constructResult.0))
        XCTAssertFalse(constructableEngine.isConstructableNew(constructResult.0))
    }
    
    func testClearAll() {
        let constructResult = constructableEngine.getConstructResult([:])
        XCTAssertTrue(constructableEngine.isConstructableActivated(constructResult.0))
        XCTAssertTrue(constructableEngine.isConstructableNew(constructResult.0))
        
        constructableEngine.clearActivated()
        XCTAssertFalse(constructableEngine.isConstructableActivated(constructResult.0))
        XCTAssertFalse(constructableEngine.isConstructableNew(constructResult.0))
    }
    
    func testNeverAppear() {
        // This is random :)
        
        for _ in 0 ..< 10000 {
            let constructResult = constructableEngine.getConstructResult([:])
            XCTAssertNotEqual(constructResult.0.id, 1)
        }
    }
}
