//
//  Entity.h
//  WTADataExample
//
//  Created by Erik LaManna on 10/29/14.
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * stringAttribute;

@end
