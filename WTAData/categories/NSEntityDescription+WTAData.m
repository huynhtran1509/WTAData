//
//  NSEntityDescription+WTAData.m
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import "NSEntityDescription+WTAData.h"

@implementation NSEntityDescription (WTAData)

- (NSAttributeDescription *)primaryAttribute
{
    return [self attributesByName][[self primaryAttributeString]];
}

- (NSString *)primaryAttributeString
{
    NSString *nameString = [self name];
    NSString *attribute = [NSString stringWithFormat:@"%@%@ID", [[nameString substringToIndex:1] lowercaseString], [nameString substringFromIndex:1]];
    
    NSString *primaryAttributeKey = [self userInfo][@"PrimaryAttribute"];
    if (primaryAttributeKey)
    {
        attribute = primaryAttributeKey;
    }
    
    return attribute;
}

@end
