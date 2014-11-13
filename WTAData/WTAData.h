//
//  WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

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
 
 :param: modelName name of the managed object model to load
 
 :returns: instance of the WTAData class
 */
- (instancetype)initWithModelNamed:(NSString*)modelName;

/**
 Initialize a data stack using the specified model. The name of the sqlite database will follow
 the name of the managed object. This function will also delete the core data store
 
 :param: modelName name of the managed object model to load
 :param: deleteOnModelMismatch delete the data store if the core data models do not match.
 
 :returns: instance of the WTAData class
 */
- (instancetype)initWithModelNamed:(NSString *)modelName
             deleteOnModelMismatch:(BOOL)deleteOnModelMismatch;

/**
 Initialize a data stack using the specified model. The name of the sqlite database will follow
 the name of the managed object. This function will also delete the core data store if there is a 
 model mismatch, and will delete the store if it fails integrity checks
 
 :param: modelName name of the managed object model to load
 :param: deleteOnModelMismatch delete the data store if the core data models do not match.
 :param: verifyStoreIntegrity set to YES to perform a store integrity check and delete the data
                              store if the check does not match.
 
 :returns: instance of the WTAData class
 */

- (instancetype)initWithModelNamed:(NSString *)modelName
             deleteOnModelMismatch:(BOOL)deleteOnModelMismatch
              verifyStoreIntegrity:(BOOL)verifyStoreIntegrity;

/**
 Initialize an in-memory data stack using the specified model.
 
 :param: modelName name of the managed object model to load
 
 :returns: instance of the WTAData class
 */
- (instancetype)initInMemoryStackWithModelNamed:(NSString*)modelName;

- (void)cleanUp;


/**
 Perform save in the specified context.
 
 :param: context the context to save on
 :param: wait YES if the operation is blocking, NO for non-blocking
 :param: work the block that operates on the managed objects to save
 :param: completion block called when the save is complete
 */
- (void)saveInContext:(NSManagedObjectContext *)context
                 wait:(BOOL)wait
                 work:(void (^)(NSManagedObjectContext *context))work
           completion:(void (^)(BOOL savedChanges, NSError *error))completion;

/**
 Perform save in the background using the backgroundContext. Changes are then propagated to 
 the main context.
 
 :param: work the block that operates on the managed objects to save
 :param: completion block called when the save is complete
 */
-(void)saveInBackground:(void (^)(NSManagedObjectContext *context))work
             completion:(void (^)(BOOL savedChanges, NSError *error))completion;

/**
 Perform save in the background using the backgroundContext and wait for completion. Changes are 
 then propagated to the main context.
 
 :param: work the block that operates on the managed objects to save
 */
-(void)saveInBackgroundAndWait:(void (^)(NSManagedObjectContext *context))work;

/**
 Perform save in the specified context.
 
 :param: context the context to save on
 :param: wait YES if the operation is blocking, NO for non-blocking
 :param: work the block that operates on the managed objects to save
 :param: completion block called when the save is complete
 */
- (void)deleteAllDataWithCompletion:(void (^)(NSError*))completion;

/**
 Deletes all of the files associated with a given model store.
 
 :param: modelName name of the managed object model to remove stores for
 */
+ (void)deleteStoreFilesForModelNamed:(NSString*)modelName;

/**
 Returns the URL for the database created with the specified store name.
 
 :param: storeName the name of the persistent store that matches this database
 
 :returns: the url for the database
 */
+ (NSURL*)databaseURLForStoreName:(NSString*)storeName;

/** 
 Returns the name of the default store pulling from the bundle name.
 
 :returns: the default bundle store
 */
+ (NSString*)defaultStoreName;

@end
