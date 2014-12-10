//
//  WTAData.h
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
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

/**
 WTAData provides a simplified interface to setting up an asynchronous CoreData stack.  WTAData 
 utilizes two NSManagedObjectContexts: a main context generally used by UI binding and a background
 context that is used to import data from an API for example.  The main context listens for
 notifications of changes on the background context and will update when the background context
 saves.  In most cases, saves will generally be done on the background context and the main context 
 is used for reading the data and responding to changes.
 */
@interface WTAData : NSObject

/// The current managed object model
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

/// Context used with concurency type NSMainQueueConcurrencyType. This context is typically used
/// for pulling data from the store and fetch requests.
@property (nonatomic, strong) NSManagedObjectContext *mainContext;

/// Context used with the concurrency type NSPrivateQueueConcurrencyType. This context is used for
/// background saving of items in the store. This is the context used by the background saving
/// functions.
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;

/// Coordinator used by the stack
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 Initialize a data stack using the specified model. The name of the sqlite database will follow
 the name of the managed object.
 
 @param modelName name of the managed object model to load
 
 @return instance of the WTAData class
 */
- (instancetype)initWithModelNamed:(NSString*)modelName;

/**
 Initialize a data stack using the specified model. The name of the sqlite database will follow
 the name of the managed object. This function will also delete the core data store
 
 @param modelName name of the managed object model to load
 @param deleteOnModelMismatch delete the data store if the core data models do not match.
 
 @return instance of the WTAData class
 */
- (instancetype)initWithModelNamed:(NSString *)modelName
             deleteOnModelMismatch:(BOOL)deleteOnModelMismatch;

/**
 Initialize a data stack using the specified model. The name of the sqlite database will follow
 the name of the managed object. This function will also delete the core data store if there is a 
 model mismatch, and will delete the store if it fails integrity checks
 
 @param modelName name of the managed object model to load
 @param deleteOnModelMismatch delete the data store if the core data models do not match.
 @param verifyStoreIntegrity set to YES to perform a store integrity check and delete the data
                              store if the check does not match.
 
 @return instance of the WTAData class
 */

- (instancetype)initWithModelNamed:(NSString *)modelName
             deleteOnModelMismatch:(BOOL)deleteOnModelMismatch
              verifyStoreIntegrity:(BOOL)verifyStoreIntegrity;

/**
 Initialize an in-memory data stack using the specified model.
 
 @param modelName name of the managed object model to load
 
 @return instance of the WTAData class
 */
- (instancetype)initInMemoryStackWithModelNamed:(NSString*)modelName;

/**
 Shuts down the core data stack and cleans up all objects.  This should be called on application
 shutdown.
 */
- (void)cleanUp;

/**
 Perform save in the specified context.
 
 @param context the context to save on
 @param wait YES if the operation is blocking, NO for non-blocking
 @param work the block that operates on the managed objects to save
 @param completion block called when the save is complete
 */
- (void)saveInContext:(NSManagedObjectContext *)context
                 wait:(BOOL)wait
                 work:(void (^)(NSManagedObjectContext *context))work
           completion:(void (^)(BOOL savedChanges, NSError *error))completion;

/**
 Perform save in the background using the backgroundContext. Changes are then propagated to 
 the main context.
 
 @param work the block that operates on the managed objects to save
 @param completion block called when the save is complete
 */
-(void)saveInBackground:(void (^)(NSManagedObjectContext *context))work
             completion:(void (^)(BOOL savedChanges, NSError *error))completion;

/**
 Perform save in the background using the backgroundContext and wait for completion. Changes are 
 then propagated to the main context.
 
 @param work the block that operates on the managed objects to save
 */
-(void)saveInBackgroundAndWait:(void (^)(NSManagedObjectContext *context))work;

/**
 Perform save in the specified context.
 
 @param context the context to save on
 @param wait YES if the operation is blocking, NO for non-blocking
 @param work the block that operates on the managed objects to save
 @param completion block called when the save is complete
 */
- (void)deleteAllDataWithCompletion:(void (^)(NSError*))completion;

#pragma mark - Static Filesystem Helpers

/**
 Deletes all of the files associated with a given model store.
 
 @param modelName name of the managed object model to remove stores for
 */
+ (void)deleteStoreFilesForModelNamed:(NSString*)modelName;

/**
 Returns the URL for the database created with the specified store name.
 
 @param storeName the name of the persistent store that matches this database
 
 @return the url for the database
 */
+ (NSURL*)databaseURLForStoreName:(NSString*)storeName;

/** 
 Returns the name of the default store pulling from the bundle name.
 
 @return the default bundle store
 */
+ (NSString*)defaultStoreName;

@end
