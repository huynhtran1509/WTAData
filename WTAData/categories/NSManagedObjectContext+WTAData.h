//
//  NSManagedObjectContext+WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (WTAData)

- (void)saveContext;

- (void)saveContextWithCompletion:(void (^)(BOOL savedChanges, NSError *error))completion;

- (void)saveBlock:(void (^)(NSManagedObjectContext *context))work
       completion:(void (^)(BOOL savedChanges, NSError *error))completion;

- (void)saveBlockAndWait:(void (^)(NSManagedObjectContext *context))work
              completion:(void (^)(BOOL savedChanges, NSError *error))completion;

@end
