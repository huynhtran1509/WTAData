//
//  WTADataExampleTests.m
//  WTADataExampleTests
//
//  Created by Erik LaManna on 10/29/14.
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WTAData.h"
#import "Entity.h"

@interface WTADataExampleTests : XCTestCase

@end

@implementation WTADataExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSaveInContext
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSaveInContext"];
    
    WTAData *data = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];
    __block Entity *entity;
    [data saveInContext:data.mainContext wait:NO work:^(NSManagedObjectContext *context) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                               inManagedObjectContext:context];
        entity.stringAttribute = @"TestSaveInContext";
    } completion:^(BOOL savedChanges, NSError *error) {

        Entity *backgroundThreadEntity = (Entity *)[data.backgroundContext existingObjectWithID:entity.objectID error:nil];
        XCTAssertNotNil(backgroundThreadEntity);
        XCTAssertEqualObjects(backgroundThreadEntity.stringAttribute, @"TestSaveInContext");
        
        [data saveInContext:data.mainContext wait:NO work:^(NSManagedObjectContext *context){
            Entity *localEntity = (Entity *)[data.backgroundContext existingObjectWithID:backgroundThreadEntity.objectID error:nil];
            localEntity.stringAttribute = @"TestUpdateInContext";
        } completion:^(BOOL savedChanges, NSError *error) {
            XCTAssertEqualObjects(backgroundThreadEntity.stringAttribute, @"TestUpdateInContext");
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testSaveInBackground
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSaveInBackground"];
    
    WTAData *data = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];
    __block Entity *entity;
    [data saveInBackground:^(NSManagedObjectContext *context) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                                       inManagedObjectContext:context];
        entity.stringAttribute = @"TestSaveInBackground";
    } completion:^(BOOL savedChanges, NSError *error) {
        
        Entity *mainThreadEntity = (Entity *)[data.mainContext existingObjectWithID:entity.objectID error:nil];
        XCTAssertNotNil(mainThreadEntity);
        XCTAssertEqualObjects(mainThreadEntity.stringAttribute, @"TestSaveInBackground");
        
        [data saveInBackground:^(NSManagedObjectContext *context) {
            Entity *localEntity = (Entity *)[data.backgroundContext existingObjectWithID:mainThreadEntity.objectID error:nil];
            localEntity.stringAttribute = @"TestUpdateInBackground";
        } completion:^(BOOL savedChanges, NSError *error) {
            XCTAssertEqualObjects(mainThreadEntity.stringAttribute, @"TestUpdateInBackground");
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testSaveInBackgroundAndWait
{
    WTAData *data = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];
    __block Entity *entity;
    [data saveInBackgroundAndWait:^(NSManagedObjectContext *context) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                               inManagedObjectContext:context];
        entity.stringAttribute = @"TestSaveInBackgroundAndWait";
    }];
    
    Entity *mainThreadEntity = (Entity *)[data.mainContext existingObjectWithID:entity.objectID error:nil];
    XCTAssertNotNil(mainThreadEntity);
    XCTAssertEqualObjects(mainThreadEntity.stringAttribute, @"TestSaveInBackgroundAndWait");
}

@end
