//
//  NSEntityDescription+WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (WTAData)

- (NSAttributeDescription *)primaryAttribute;
- (NSString *)primaryAttributeString;

@end
