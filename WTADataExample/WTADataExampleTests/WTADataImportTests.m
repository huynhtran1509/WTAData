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
#import "NSManagedObject+WTADataImport.h"

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

- (void)testImportArrayPrimaryKey
{
    NSDictionary *entityWithMissingPrimaryAttribute = @{@"customPrimaryKey": @"KEY001",
                                                        @"data": @"Test data"};
    
    NSArray *importedObjects = [PrimaryKeyEntity importEntitiesFromArray:@[entityWithMissingPrimaryAttribute]
                                                                 context:self.wtaData.mainContext];
    
    XCTAssert((importedObjects.count == 1), @"Missing primary key should not return import objects");
    
}


@end
