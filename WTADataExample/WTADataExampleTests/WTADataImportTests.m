//
//  WTADataImportTests.m
//  WTADataExample
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
#import "PrimaryKeyEntity.h"
#import "RelationshipEntity.h"
#import "NSManagedObject+WTADataImport.h"
#import "NSManagedObject+WTAData.h"
#import "Entity.h"

@interface WTADataImportTests : XCTestCase

@property (nonatomic, strong) WTAData *wtaData;

@end

@implementation WTADataImportTests

- (void)setUp {
    [super setUp];
    self.wtaData = [[WTAData alloc] initInMemoryStackWithModelNamed:@"WTADataExample"];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// Test case when an import array is missing the primary key
- (void)testImportArrayMissingPrimaryKey
{
    NSDictionary *entityWithMissingPrimaryAttribute = @{@"data": @"Test data"};
    
    NSArray *importedObjects = [PrimaryKeyEntity importEntitiesFromArray:@[entityWithMissingPrimaryAttribute]
                                                                 context:self.wtaData.mainContext];
    
    XCTAssert((importedObjects.count == 0), @"Missing primary key should not return import objects");

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

- (void)testDefaultDateFormat
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:[NSDateFormatter defaultImportDateFormat]];
    
    
    NSDictionary *dictionary = @{
                                 @"dateAttribute" : [dateFormatter stringFromDate:now],
                                 };
    
    NSManagedObjectContext *context = [[self wtaData] mainContext];
    Entity *entity = [Entity importEntityFromObject:dictionary context:context];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    XCTAssert([calendar compareDate:[entity dateAttribute]
                             toDate:now
                  toUnitGranularity:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear] == NSOrderedSame);
}

- (void)testCustomDefaultDateFormat
{
    NSDate *now = [NSDate date];
    
    NSString *currentDateFormat = [NSDateFormatter defaultImportDateFormat];
    
    NSString *customDateFormat = @"M/d/yyyy";
    
    [NSDateFormatter setDefaultImportDateFormat:customDateFormat];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:customDateFormat];
    
    
    NSDictionary *dictionary = @{
                                 @"dateAttribute" : [dateFormatter stringFromDate:now],
                                 };
    
    NSManagedObjectContext *context = [[self wtaData] mainContext];
    Entity *entity = [Entity importEntityFromObject:dictionary context:context];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    XCTAssert([calendar compareDate:[entity dateAttribute]
                             toDate:now
                  toUnitGranularity:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear] == NSOrderedSame);
    
    [NSDateFormatter setDefaultImportDateFormat:currentDateFormat];
}

#pragma mark - Array Imports

- (void)testImportArrayPrimaryKey
{
    NSDictionary *entityWithMissingPrimaryAttribute = @{@"customPrimaryKey": @"KEY001",
                                                        @"data": @"Test data"};
    
    NSArray *importedObjects = [PrimaryKeyEntity importEntitiesFromArray:@[entityWithMissingPrimaryAttribute]
                                                                 context:self.wtaData.mainContext];
    
    XCTAssert((importedObjects.count == 1), @"Missing primary key should not return import objects");
    
}

- (void)testImportArrayWithNSNull
{
    NSString* testData = @"Test data";
    
    NSDictionary *entityWithDataContent = @{@"customPrimaryKey": @"KEY001",
                                            @"data": testData};
    
    NSArray *importedObjects = [PrimaryKeyEntity importEntitiesFromArray:@[entityWithDataContent]
                                                                 context:self.wtaData.mainContext];
    XCTAssert((importedObjects.count == 1), @"Basic import with primary key and test data failed");
    
    
    // Fetch and check data isEqualTo testData
    NSArray* entities = [PrimaryKeyEntity fetchInContext:self.wtaData.mainContext error:nil];
    XCTAssert((entities.count == 1), @"Basic import with primary key and test data failed");
    
    PrimaryKeyEntity* entity = entities[0];
    XCTAssert(([testData isEqualToString:entity.data]),@"Basic import with primary key and good test data failed to fetch");
    
    
    // Import testData as NSNull (i.e. when server api sends "data" : null josn)
    NSDictionary *entityWithDataNSNull = @{@"customPrimaryKey": @"KEY001",
                                           @"data": [NSNull null]};
    importedObjects = [PrimaryKeyEntity importEntitiesFromArray:@[entityWithDataNSNull]
                                                                 context:self.wtaData.mainContext];
    XCTAssert((importedObjects.count == 1), @"Import with primary key and test data as NSNull failed");
    
    // Fetch and check data isEqualTo nil isEqual:[NSNull null]
    entities = [PrimaryKeyEntity fetchInContext:self.wtaData.mainContext error:nil];
    XCTAssert((entities.count == 1), @"Import with primary key and test data as NSNull failed");
    
    entity = entities[0];
    XCTAssertNotNil(entity,@"Import with primary key and test data as NSNull failed");
    XCTAssertNil(entity.data, @"Import with primary key and test data as NSNull failed to set data to nil");
    
}

#pragma mark - Custom Import Overrides

- (void)testCustomImportString
{
    NSDictionary *entityWithDataContent = @{@"customPrimaryKey": @"KEY001",
                                            @"customImportString": @"import string"};
    
    PrimaryKeyEntity *entity = [PrimaryKeyEntity importEntityFromObject:entityWithDataContent
                                                                context:self.wtaData.mainContext];
    
    XCTAssertNotNil(entity);
    XCTAssert([entity.customImportString isEqualToString:@"CUSTOM IMPORTED: import string"],
             "Custom import returned invalid string");
}

#pragma mark - Relationship Merge Tests

- (void)testImportRelationshipWithReplaceMergePolicy
{
    NSDictionary *entityWithInitialRelationships = @{@"customPrimaryKey": @"KEY001",
                                                     @"replaceEntities": @[
                                                             @{@"primaryKey": @1, @"testString": @"primaryKey1"},
                                                             @{@"primaryKey": @2, @"testString": @"primaryKey2"},
                                                             @{@"primaryKey": @3, @"testString": @"primaryKey3"},
                                                             @{@"primaryKey": @4, @"testString": @"primaryKey4"},
                                                             ]};
    PrimaryKeyEntity *importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithInitialRelationships
                                                               context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    XCTAssertTrue(importedObject.replaceEntities.count == 4);
    
    NSArray *relationshipEntities = [self sortedRelationshipEnityArray:importedObject.replaceEntities];
    RelationshipEntity *lastEntity = [relationshipEntities lastObject];
    
    NSDictionary *entityWithUpdateAndNew = @{@"customPrimaryKey": @"KEY001",
                                             @"replaceEntities": @[
                                                     @{@"primaryKey": @4, @"testString": @"primaryKey4"},
                                                     @{@"primaryKey": @5, @"testString": @"primaryKey5"},
                                                     ]};
    
    importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithUpdateAndNew
                                                      context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    XCTAssertTrue(importedObject.replaceEntities.count == 2);

    relationshipEntities = [self sortedRelationshipEnityArray:importedObject.replaceEntities];
    
    // Make sure objects are actually deleted and replaced
    XCTAssert(lastEntity != relationshipEntities.firstObject, "Managed Relationship object was not replaced");

    NSUInteger keyCount = 4;
    
    for (RelationshipEntity *relationshipEntity in relationshipEntities)
    {
        XCTAssert([[NSNumber numberWithUnsignedInteger:keyCount] isEqualToNumber:relationshipEntity.primaryKey],
                  "Imported keys should match");
        keyCount++;
    }
}


- (void)testImportRelationshipWithMergingMergePolicy
{
    NSDictionary *entityWithInitialRelationships = @{@"customPrimaryKey": @"KEY001",
                                                     @"mergeEntities": @[
                                                             @{@"primaryKey": @1, @"testString": @"primaryKey1"},
                                                             @{@"primaryKey": @2, @"testString": @"primaryKey2"},
                                                             @{@"primaryKey": @3, @"testString": @"primaryKey3"},
                                                             ]};
    PrimaryKeyEntity *importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithInitialRelationships
                                                                        context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    XCTAssertTrue(importedObject.mergeEntities.count == 3);
    
    NSArray *relationshipEntities = [self sortedRelationshipEnityArray:importedObject.mergeEntities];
    RelationshipEntity *firstEntity = [relationshipEntities firstObject];
    
    NSDictionary *entityWithUpdateAndNew = @{@"customPrimaryKey": @"KEY001",
                                             @"mergeEntities": @[
                                                     @{@"primaryKey": @1, @"testString": @"updated primaryKey1"},
                                                     @{@"primaryKey": @4, @"testString": @"primaryKey4"},
                                                     @{@"primaryKey": @5, @"testString": @"primaryKey5"},
                                                     ]};
    
    importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithUpdateAndNew
                                                      context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    XCTAssertTrue(importedObject.mergeEntities.count == 5);
    
    relationshipEntities = [self sortedRelationshipEnityArray:importedObject.mergeEntities];
    
    XCTAssert(firstEntity == relationshipEntities.firstObject,
              "Entity was not merged retaining object ID");
    XCTAssert([firstEntity.testString isEqualToString:@"updated primaryKey1"],
              "Attribute on existing entity was not updated.");
    
    NSUInteger keyCount = 1;
    
    for (RelationshipEntity *relationshipEntity in relationshipEntities)
    {
        XCTAssert([[NSNumber numberWithUnsignedInteger:keyCount] isEqualToNumber:relationshipEntity.primaryKey],
                  "Imported keys should match");
        keyCount++;
    }
    
    XCTAssert(keyCount == 6, "The proper number of items were not imported");
}

- (void)testImportRelationshipWithMergeAndPruneMergePolicy
{
    NSDictionary *entityWithInitialRelationships = @{@"customPrimaryKey": @"KEY001",
                                                     @"mergeAndPruneEntities": @[
                                                             @{@"primaryKey": @1, @"testString": @"primaryKey1"},
                                                             @{@"primaryKey": @2, @"testString": @"primaryKey2"},
                                                             @{@"primaryKey": @3, @"testString": @"primaryKey3"},
                                                             ]};
    PrimaryKeyEntity *importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithInitialRelationships
                                                                        context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    XCTAssertTrue(importedObject.mergeAndPruneEntities.count == 3);
    
    NSArray *relationshipEntities = [self sortedRelationshipEnityArray:importedObject.mergeAndPruneEntities];
    RelationshipEntity *firstEntity = relationshipEntities[0];
    
    NSDictionary *entityWithUpdateAndNew = @{@"customPrimaryKey": @"KEY001",
                                             @"mergeAndPruneEntities": @[
                                                     @{@"primaryKey": @1, @"testString": @"Updated Primary Key 1"},
                                                     @{@"primaryKey": @5, @"testString": @"primaryKey5"},
                                                     ]};
    
    importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithUpdateAndNew
                      
                                                      context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    XCTAssertTrue(importedObject.mergeAndPruneEntities.count == 2);
    
    relationshipEntities = [self sortedRelationshipEnityArray:importedObject.mergeAndPruneEntities];
    
    RelationshipEntity *updatedFirstEntity = relationshipEntities[0];
    XCTAssert(updatedFirstEntity == firstEntity, "First object was not properly updated");
    XCTAssert(firstEntity.primaryKey.unsignedIntegerValue == 1, "First entity should have key of 1");
    XCTAssert([firstEntity.testString isEqualToString:@"Updated Primary Key 1"], "First entity should have been updated with new test string");
    
    RelationshipEntity *secondEntity = relationshipEntities[1];
    XCTAssert(secondEntity.primaryKey.unsignedIntegerValue == 5, "Second entity should have key of 5");
}


#pragma mark - Relationship Single Item Merge Tests
- (void)testImportSingleRelationshipWithReplaceMergePolicy
{
    NSDictionary *entityWithInitialRelationships = @{@"customPrimaryKey": @"KEY001",
                                                     @"replaceSingleEntity":
                                                             @{@"primaryKey": @1, @"testString": @"primaryKey1"}
                                                             };
    PrimaryKeyEntity *importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithInitialRelationships
                                                                        context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    
    RelationshipEntity *lastEntity = (RelationshipEntity*)importedObject.replaceSingleEntity;
    
    NSDictionary *entityWithUpdateAndNew = @{@"customPrimaryKey": @"KEY001",
                                             @"replaceSingleEntity":
                                                     @{@"primaryKey": @1, @"testString": @"updatedPrimaryKey"},
                                                     };
    
    importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithUpdateAndNew
                                                      context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject.replaceSingleEntity, "Imported object should not be nil");
    
    // Make sure objects are actually deleted and replaced
    XCTAssert(lastEntity != importedObject.replaceSingleEntity, "Managed Relationship object was not replaced");
    XCTAssert([((RelationshipEntity*)importedObject.replaceSingleEntity).testString isEqualToString:@"updatedPrimaryKey"],
              "Object testString was not properly updated.");
}


- (void)testImportSingleRelationshipWithMergingMergePolicy
{
    NSDictionary *entityWithInitialRelationships = @{@"customPrimaryKey": @"KEY001",
                                                     @"mergeSingleEntity":
                                                         @{@"primaryKey": @1, @"testString": @"primaryKey1"}
                                                     };
    PrimaryKeyEntity *importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithInitialRelationships
                                                                        context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    
    RelationshipEntity *lastEntity = (RelationshipEntity*)importedObject.mergeSingleEntity;
    
    NSDictionary *entityWithUpdateAndNew = @{@"customPrimaryKey": @"KEY001",
                                             @"mergeSingleEntity":
                                                 @{@"primaryKey": @1, @"testString": @"updatedPrimaryKey"},
                                             };
    
    importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithUpdateAndNew
                                                      context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject.mergeSingleEntity, "Imported object should not be nil");
    
    // Make sure objects are actually deleted and replaced
    XCTAssert(lastEntity == importedObject.mergeSingleEntity, "Managed Relationship object was replaced");
    XCTAssert([((RelationshipEntity*)importedObject.mergeSingleEntity).testString isEqualToString:@"updatedPrimaryKey"],
              "Object testString was not properly updated.");
}

- (void)testImportSingleRelationshipWithMergeAndPruneMergePolicy
{
    NSDictionary *entityWithInitialRelationships = @{@"customPrimaryKey": @"KEY001",
                                                     @"mergeAndPruneSingleEntity":
                                                         @{@"primaryKey": @1, @"testString": @"primaryKey1"}
                                                     };
    PrimaryKeyEntity *importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithInitialRelationships
                                                                        context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject, "Imported object should not be nil");
    
    RelationshipEntity *lastEntity = (RelationshipEntity*)importedObject.mergeAndPruneSingleEntity;
    
    NSDictionary *entityWithUpdateAndNew = @{@"customPrimaryKey": @"KEY001",
                                             @"mergeAndPruneSingleEntity":
                                                 @{@"primaryKey": @1, @"testString": @"updatedPrimaryKey"},
                                             };
    
    importedObject = [PrimaryKeyEntity importEntityFromObject:entityWithUpdateAndNew
                                                      context:self.wtaData.mainContext];
    
    XCTAssertNotNil(importedObject.mergeAndPruneSingleEntity, "Imported object should not be nil");
    
    // Make sure objects are actually deleted and replaced
    XCTAssert(lastEntity == importedObject.mergeAndPruneSingleEntity, "Managed Relationship object was replaced");
    XCTAssert([((RelationshipEntity*)importedObject.mergeAndPruneSingleEntity).testString isEqualToString:@"updatedPrimaryKey"],
              "Object testString was not properly updated.");

}

#pragma mark - Test Helpers

- (NSArray*)sortedRelationshipEnityArray:(NSSet*)relationships
{
    NSArray *relationshipEntities = [relationships allObjects];
    relationshipEntities = [relationshipEntities sortedArrayUsingComparator:^NSComparisonResult(RelationshipEntity *obj1, RelationshipEntity* obj2) {
        return [obj1.primaryKey compare:obj2.primaryKey];
    }];
    
    return relationshipEntities;
}

@end












