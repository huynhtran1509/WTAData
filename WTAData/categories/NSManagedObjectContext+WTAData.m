//
//  NSManagedObjectContext+WTAData.m
//  WTAData
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
    if (work)
    {
        [self performBlock:^{
            work(self);
            [self saveContextWithCompletion:completion];
        }];
    }
}

- (void)saveBlockAndWait:(void (^)(NSManagedObjectContext *context))work
              completion:(void (^)(BOOL savedChanges, NSError *error))completion
{
    if (work)
    {
        [self performBlockAndWait:^{
            work(self);
            [self saveContextWithCompletion:completion];
        }];
    }
}

@end
