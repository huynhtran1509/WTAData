//
//  WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "WTADataConfiguration.h"

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

/// The stack configuration
@property (nonatomic, strong, readonly) WTADataConfiguration *configuration;

/**
 Initialize a data stack using the specified configuration.
 
 :param: configuration the configuration defining resource disk location and options
 
 :returns: instance of the WTAData class
 */
- (instancetype)initWithConfiguration:(WTADataConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 Initialize a data stack using the specified model. The name of the sqlite database will follow
 the name of the managed object.
 
 :param: modelName name of the managed object model to load
 
 :returns: instance of the WTAData class
 */
- (instancetype)initWithModelNamed:(NSString *)modelName;

/**
 Initialize an in-memory data stack using the specified model.
 
 :param: modelName name of the managed object model to load
 
 :returns: instance of the WTAData class
 */
- (instancetype)initInMemoryStackWithModelNamed:(NSString *)modelName;

/**
 Shuts down the core data stack and cleans up all objects.  This should be called on application
 shutdown.
 */
- (void)invalidateStack;

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
 :returns: YES if save was successful
 */
-(BOOL)saveInBackgroundAndWait:(void (^)(NSManagedObjectContext *context))work error:(NSError **)error;

/**
 Perform save in the specified context.
 
 :param: context the context to save on
 :param: wait YES if the operation is blocking, NO for non-blocking
 :param: work the block that operates on the managed objects to save
 :param: completion block called when the save is complete
 */
- (void)deleteAllDataWithCompletion:(void (^)(NSError *))completion;

@end
