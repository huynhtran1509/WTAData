//
//  WillowTreeDataExampleTests.swift
//  WTADataExample
//
//  Created by Robert Thompson on 11/10/15.
//  Copyright © 2015 WillowTree, Inc. All rights reserved.
//

import XCTest
@testable import WTADataExample

class WillowTreeDataExampleTests: XCTestCase {
    var data: DataController!
    
    override func setUp() {
        super.setUp()
        data = DataController(persistentStores: [PersistentStore(storeType: NSInMemoryStoreType)])
    }
    
    func testSaveAndWait() {
        
        do {
            try data.save()
        } catch {
            XCTAssertTrue(false, "Error thrown during save: \(error)")
        }
        
        XCTAssertTrue(true)
    }
    
}
