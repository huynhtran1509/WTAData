//
//  WTADataSwiftIntegrationTests.swift
//  WTADataExample
//
//  Created by Erik LaManna on 1/29/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import XCTest

class WTADataSwiftIntegrationTests: XCTestCase {
    
    var wtaData: WTAData!
    
    override func setUp() {
        super.setUp()

        wtaData = WTAData(inMemoryStackWithModelNamed: "WTADataExample")
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeleteAllSwift() {
        SwiftEntity.createEntityInContext(wtaData.mainContext!)
        
        wtaData.mainContext?.saveContext()
        
        SwiftEntity.deleteAllInContext(wtaData.mainContext!)
        
        do {
            let items = try SwiftEntity.fetchInContext(wtaData.mainContext!)
            XCTAssertEqual(items.count, 0, "All entities not deleted")
        } catch _ {
            XCTFail("Failed to fetch things")
        }
        
        
    }
}
