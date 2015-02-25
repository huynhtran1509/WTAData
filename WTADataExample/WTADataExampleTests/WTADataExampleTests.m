//
//  WTADataExampleTests.m
//  WTADataExampleTests
//
//  Copyright (c) 2014 WillowTree, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WTAData.h"
#import "Entity.h"
#import "NSManagedObjectContext+WTAData.h"
#import "NSManagedObject+WTAData.h"
#import "NSManagedObject+WTADataImport.h"

@interface WTADataExampleTests : XCTestCase

@property (nonatomic, strong) WTAData *wtaData;

@end

@implementation WTADataExampleTests

- (void)setUp {
    [super setUp];
    self.wtaData = [[WTAData alloc] initInMemoryStackWithModelNamed:@"WTADataExample"];
    //self.wtaData = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSaveAndWait {
    
    __block BOOL stepOneFinished = NO;
   
    [self.wtaData.mainContext saveBlockAndWait:^(NSManagedObjectContext *context) {
        
        XCTAssertTrue(stepOneFinished == NO);
        stepOneFinished = YES;
        
    } error:nil];
    
    XCTAssertTrue(stepOneFinished);
}

- (void)testSaveInContext
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSaveInContext"];
    
    NSString *const initialStringValue = @"TestSaveInContext";
    NSString *const updatedStringValue = @"TestUpdateInContext";
    
    __block Entity *entity;
    
    [self.wtaData.mainContext saveBlock:^(NSManagedObjectContext *context) {
       
        //Given
        entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                               inManagedObjectContext:context];
        entity.stringAttribute = initialStringValue;
        
    } completion:^(BOOL savedChanges, NSError *error) {
       
        //When
        Entity *backgroundThreadEntity = (Entity *)[self.wtaData.backgroundContext existingObjectWithID:entity.objectID error:nil];
        
        //Then
        XCTAssertNotNil(backgroundThreadEntity);
        XCTAssertEqualObjects(backgroundThreadEntity.stringAttribute, initialStringValue);
        
        [self.wtaData.backgroundContext saveBlock:^(NSManagedObjectContext *context) {
            //Given
            Entity *localEntity = (Entity *)[self.wtaData.backgroundContext existingObjectWithID:backgroundThreadEntity.objectID error:nil];
            
            //When
            localEntity.stringAttribute = updatedStringValue;
        } completion:^(BOOL savedChanges, NSError *error) {
            //Then
            XCTAssertEqualObjects(backgroundThreadEntity.stringAttribute, updatedStringValue);
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
    
    NSString *const initialStringValue = @"TestSaveInBackground";
    NSString *const updatedStringValue = @"TestUpdateInBackground";
    
    __weak typeof(self) weakSelf = self;
    __block Entity *entity;
    [self.wtaData saveInBackground:^(NSManagedObjectContext *context) {
        //Given
        entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                                       inManagedObjectContext:context];
        entity.stringAttribute = initialStringValue;
    } completion:^(BOOL savedChanges, NSError *error) {
        //When
        Entity *mainThreadEntity = (Entity *)[self.wtaData.mainContext existingObjectWithID:entity.objectID error:nil];
        
        //Then
        XCTAssertNotNil(mainThreadEntity);
        XCTAssertTrue([[mainThreadEntity stringAttribute] isEqualToString:initialStringValue]);
        
        [weakSelf.wtaData saveInBackground:^(NSManagedObjectContext *context) {
            //Given
            Entity *localEntity = (Entity *)[self.wtaData.backgroundContext existingObjectWithID:mainThreadEntity.objectID error:nil];
            
            //When
            localEntity.stringAttribute = updatedStringValue;
        } completion:^(BOOL savedChanges, NSError *error) {
            //Then
            
            XCTAssertTrue([[mainThreadEntity stringAttribute] isEqualToString:updatedStringValue]);
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testDateFormatImport
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *ISO8601DateFormater = [NSDateFormatter new];
    [ISO8601DateFormater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSDateFormatter *customFormatter = [NSDateFormatter new];
    [customFormatter setDateFormat:@"M/d/yyyy"];
    
    NSDictionary *dictionary = @{
                                 @"epochDateAttribute" : @([now timeIntervalSince1970]),
                                 @"dateAttribute" : [ISO8601DateFormater stringFromDate:now],
                                 @"customDateAttribute" : [customFormatter stringFromDate:now]
                                 };
    
    NSManagedObjectContext *context = [[self wtaData] mainContext];
    Entity *entity = [Entity importEntityFromObject:dictionary context:context];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    XCTAssert([calendar compareDate:[entity dateAttribute]
                             toDate:now
                  toUnitGranularity:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear] == NSOrderedSame);
    
    XCTAssert([calendar compareDate:[entity customDateAttribute]
                             toDate:now
                  toUnitGranularity:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear] == NSOrderedSame);
    
    XCTAssert([calendar compareDate:[entity epochDateAttribute]
                             toDate:now
                  toUnitGranularity:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear] == NSOrderedSame);
}

- (void)testSaveInBackgroundAndWait
{
    NSString *const initialStringValue = @"TestSaveInBackgroundAndWait";

    __weak typeof(self) weakSelf = self;
    __block Entity *entity;
    [weakSelf.wtaData saveInBackgroundAndWait:^(NSManagedObjectContext *context) {
        //Given
        entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                               inManagedObjectContext:context];
        entity.stringAttribute = initialStringValue;
    } error:nil];
    //When
    Entity *mainThreadEntity = (Entity *)[self.wtaData.mainContext existingObjectWithID:entity.objectID error:nil];
    
    //Then
    XCTAssertNotNil(mainThreadEntity);
    XCTAssertEqualObjects(mainThreadEntity.stringAttribute, initialStringValue);
}


- (void)testDeleteAllDataWithCompletion
{
    //Given
    [self.wtaData saveInBackgroundAndWait:^(NSManagedObjectContext *context) {
        //Given
        Entity *entity = [NSEntityDescription insertNewObjectForEntityForName:[[Entity class] description]
                                               inManagedObjectContext:context];
        entity.stringAttribute = @"Insert an object to delete";
    } error:nil];
    
    NSUInteger count = 0;
    NSArray *entities = [self.wtaData.managedObjectModel entities];
    for (NSEntityDescription *entityDescription in entities) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
        NSArray *items = [self.wtaData.mainContext executeFetchRequest:fetchRequest error:nil];
        count += [items count];
    }
    
    NSLog(@"Starting number of objects: %lu", (unsigned long)count);
 
    XCTestExpectation *expectation = [self expectationWithDescription:@"testDeleteAllDataWithCompletion"];
    
    __weak typeof(self) weakSelf = self;
    [self.wtaData deleteAllDataWithCompletion:^(NSError *error) {
        //When
        NSUInteger count = 0;
        NSArray *entities = [weakSelf.wtaData.managedObjectModel entities];
        for (NSEntityDescription *entityDescription in entities) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
            NSArray *items = [weakSelf.wtaData.mainContext executeFetchRequest:fetchRequest error:nil];
            count += [items count];
        }
        
        //Then
        XCTAssertEqual(count, 0);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100000.0 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}


@end
