//
//  WTADataConfiguration.h
//  WTADataExample
//
//  Created by Joel Garrett on 2/4/15.
//  Copyright (c) 2015 WillowTreeApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTADataConfiguration : NSObject

/// the fully qualified path to the managed object model file
@property (nonatomic, copy) NSURL *managedObjectModelFileURL;

/// the fully qualified path to the persistent store file
@property (nonatomic, copy) NSURL *persistentStoreFileURL;

/// the persistent store coordinator options. @See NSPersistentStoreCoordinator
@property (nonatomic, copy) NSDictionary *persistentStoreCoordinatorOptions;

/// set to YES to delete the existing data store if the managed object model versions do not match.
@property (nonatomic, readwrite) BOOL shouldDeleteStoreFileOnModelMismatch;

/// set to YES to perform a store integrity check and delete the data store if the check fails.
@property (nonatomic, readwrite) BOOL shouldDeleteStoreFileOnIntegrityErrors;

/// set to YES to use an in memory store instead of the sqlite default
@property (nonatomic, readwrite) BOOL shouldUseInMemoryStore;

/**
 Initialize a data configuration using the specified model. The name of the sqlite database will follow
 the name of the managed object model.
 
 :param: modelName name of the managed object model to load
 
 :returns: instance of the WTADataConfiguration class
 */
+ (instancetype)defaultConfigurationWithModelNamed:(NSString *)modelName;

/// Returns default persistent store coordinator options for use in creating a custom configuration.
+ (NSDictionary *)defaultPersistentStoreCoordinatorOptions;

/// Returns the application support directory for use in defining custom persistent store file location.
+ (NSURL *)applicationSupportDirectoryURL;

/**
 Deletes all of the files associated with a given store.
 
 :param: error the file system error if unable to delete
 
 :return: returns YES if the delete is successful
 */
- (BOOL)deleteExistingStoreFile:(NSError **)error;

@end
