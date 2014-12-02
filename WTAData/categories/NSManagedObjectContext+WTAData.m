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
    [self saveContextWithCompletion:nil];
}

- (void)saveContextWithCompletion:(void (^)(BOOL savedChanges, NSError *error))completion
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
    
    if (!hasChanges)
    {
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
        }
        return;
    }
    
    BOOL saveResult = NO;
    NSError *error = nil;
    @try
    {
        saveResult = [self save:&error];
    }
    @catch(NSException *exception)
    {
        NSLog(@"Unable to perform save: %@", (id)[exception userInfo] ?: (id)[exception reason]);
    }
    @finally
    {
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(saveResult, error);
            });
        }
    }
}

- (void)saveBlock:(void (^)(NSManagedObjectContext *context))work
       completion:(void (^)(BOOL savedChanges, NSError *error))completion
{
    NSParameterAssert(work);
    [self performBlock:^{
        work(self);
        [self saveContextWithCompletion:completion];
    }];
}

- (void)saveBlockAndWait:(void (^)(NSManagedObjectContext *context))work
              completion:(void (^)(BOOL savedChanges, NSError *error))completion
{
    NSParameterAssert(work);
    [self performBlockAndWait:^{
        work(self);
        [self saveContextWithCompletion:completion];
    }];
}

@end
