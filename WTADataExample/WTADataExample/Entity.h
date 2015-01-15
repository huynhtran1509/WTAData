//
//  Entity.h
//  WTADataExample
//
//  Created by Andrew Carter on 1/15/15.
//  Copyright (c) 2015 WillowTreeApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * stringAttribute;
@property (nonatomic, retain) NSDate * customDateAttribute;
@property (nonatomic, retain) NSDate * epochDateAttribute;
@property (nonatomic, retain) NSDate * dateAttribute;

@end
