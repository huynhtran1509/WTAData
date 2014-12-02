//
//  NSManagedObjectContext+WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (WTAData)

- (void)saveContext;
- (BOOL)saveContext:(NSError **)error;

- (void)saveBlock:(void (^)(NSManagedObjectContext *context))work
       completion:(void (^)(BOOL savedChanges, NSError *error))completion;

- (BOOL)saveBlockAndWait:(void (^)(NSManagedObjectContext *context))work error:(NSError **)error;

@end
