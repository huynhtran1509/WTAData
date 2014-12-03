//
//  NSManagedObjectContext+WTAData.m
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import "NSManagedObjectContext+WTAData.h"

@implementation NSManagedObjectContext (WTAData)

- (void)saveContext
{
    [self saveContext:nil];
}

- (BOOL)saveContext:(NSError **)error
{
    __block BOOL hasChanges = NO;
    if ([self concurrencyType] == NSConfinementConcurrencyType)
    {
        hasChanges = [self hasChanges];
    }
    else
    {
        [self performBlockAndWait:^{
            hasChanges = [self hasChanges];
        }];
    }
    
    __block BOOL saveResult = NO;
    @try
    {
        if ([self concurrencyType] == NSConfinementConcurrencyType)
        {
            saveResult = [self save:nil];
        }
        else
        {
            [self performBlockAndWait:^{
                saveResult = [self save:error];
            }];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"Unable to perform save: %@", (id)[exception userInfo] ?: (id)[exception reason]);
    }
    
    return saveResult;
}

- (void)saveBlock:(void (^)(NSManagedObjectContext *context))work
       completion:(void (^)(BOOL savedChanges, NSError *error))completion
{
    NSParameterAssert(work);
    [self performBlock:^{
        work(self);
        
        NSError *error = nil;
        BOOL result = [self saveContext:&error];
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result, error);
            });
        }
    }];
}

- (BOOL)saveBlockAndWait:(void (^)(NSManagedObjectContext *context))work error:(NSError **)error
{
    NSParameterAssert(work);
    [self performBlockAndWait:^{
        work(self);
    }];
    
    BOOL result = [self saveContext:error];
    return result;
}

@end
