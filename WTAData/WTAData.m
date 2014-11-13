//
//  WTAData.m
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import "WTAData.h"

#import "NSManagedObjectContext+WTAData.h"
#import "NSManagedObject+WTAData.h"

@implementation WTAData

- (instancetype)initWithModelNamed:(NSString *)modelName
{
    return [self initWithModelNamed:modelName deleteOnModelMismatch:NO];
}

- (instancetype)initWithModelNamed:(NSString *)modelName
             deleteOnModelMismatch:(BOOL)deleteOnModelMismatch
{
    return [self initWithModelNamed:modelName deleteOnModelMismatch:deleteOnModelMismatch verifyStoreIntegrity:NO inMemory:NO];
}

- (instancetype)initWithModelNamed:(NSString *)modelName
             deleteOnModelMismatch:(BOOL)deleteOnModelMismatch
              verifyStoreIntegrity:(BOOL)verifyStoreIntegrity
{
    return [self initWithModelNamed:modelName
              deleteOnModelMismatch:deleteOnModelMismatch
               verifyStoreIntegrity:verifyStoreIntegrity
                           inMemory:NO];
}


- (instancetype)initInMemoryStackWithModelNamed:(NSString*)modelName
{
    return [self initWithModelNamed:modelName deleteOnModelMismatch:NO verifyStoreIntegrity:NO inMemory:YES];
}

- (instancetype)initWithModelNamed:(NSString *)modelName
             deleteOnModelMismatch:(BOOL)deleteOnModelMismatch
              verifyStoreIntegrity:(BOOL)verifyStoreIntegrity
                          inMemory:(BOOL)inMemory
{
    self = [super init];
    if (self)
    {
        if (!modelName)
        {
            modelName = [WTAData defaultStoreName];
        }
        
        [self setupContextsForModelNamed:modelName];
        
        if (inMemory) {
            [self setupPersistentStoreInMemory];
        }
        else {
            [self setupPersistentStoreForModelNamed:modelName
                              deleteOnModelMismatch:deleteOnModelMismatch
                               verifyStoreIntegrity:verifyStoreIntegrity];
        }
    }
    
    return self;
}


- (void)setupContextsForModelNamed:(NSString *)modelName
{
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSAssert(self.managedObjectModel, @"Could not locate model %@", [modelURL path]);
    
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    self.backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    // register mainContext to listen and marge in changes from the background context
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundContextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.backgroundContext];
    
}

- (void)setupPersistentStoreInMemory
{
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @(NO),
                              NSInferMappingModelAutomaticallyOption: @(YES)
                              };
    
    NSError *error;
    NSPersistentStore *persistentStore = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSInMemoryStoreType
                                                                                         configuration:nil
                                                                                                   URL:nil
                                                                                               options:options
                                                                                                 error:&error];
    if (!persistentStore) {
        if (error) {
            abort();
        }
    }
}

- (void)setupPersistentStoreForModelNamed:(NSString*)modelName
            deleteOnModelMismatch:(BOOL)deleteOnModelMismatch
                     verifyStoreIntegrity:(BOOL)verifyStoreIntegrity
{
    [self createDirectoryAtPath:[[WTAData databaseDirectory] relativePath]];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                                                                   NSInferMappingModelAutomaticallyOption: @(YES)
                                                                                   }];
    if (verifyStoreIntegrity)
    {
        [options addEntriesFromDictionary:@{
                                           @"NSSQLitePragmasOption": @{@"integrity_check": @YES}
                                           }];
    }
    
    
    
    NSURL *databaseURL = [WTAData databaseURLForStoreName:modelName];
    
    // Add sqlite store to coordinator
    NSError *error;
    NSPersistentStore *persistentStore = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType
                                                                                         configuration:nil
                                                                                                   URL:databaseURL
                                                                                               options:options
                                                                                                 error:&error];
    if (!persistentStore)
    {
        if (deleteOnModelMismatch || verifyStoreIntegrity) // TOdO add option for core data mismatch
        {
            if ([[error domain] isEqualToString:NSCocoaErrorDomain] &&
                ([error code] == NSPersistentStoreIncompatibleVersionHashError ||
                [error code] == NSMigrationMissingSourceModelError))
            {
                // Remove old database
                [WTAData deleteStoreFilesForModelNamed:modelName];
#ifdef DEBUG
                NSLog(@"Removed incompatible model version: %@", databaseURL);
#endif
                
                // Try one more time to create the store
                NSPersistentStore *store = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType
                                                                                           configuration:nil
                                                                                                     URL:databaseURL
                                                                                                 options:options
                                                                                                   error:&error];
                if (store)
                {
                    // If we successfully added a store, remove the error that was initially created
                    error = nil;
                }
            }
        }
        
#ifdef DEBUG
        NSLog(@"%@", [error localizedDescription]);
#endif
        if (error)
        {
            abort();
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cleanUp
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.mainContext = nil;
    self.backgroundContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
}

- (void)backgroundContextDidSave:(NSNotification*)notification
{
    [self.mainContext performBlock:^{
        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

- (void)saveInContext:(NSManagedObjectContext *)context
                 wait:(BOOL)wait
                 work:(void (^)(NSManagedObjectContext *context))work
           completion:(void (^)(BOOL savedChanges, NSError *error))completion
{
    if (work)
    {
        if (wait)
        {
            [context performBlockAndWait:^{
                work(context);
                [context saveContextWithCompletion:completion];
            }];
        }
        else
        {
            [context performBlock:^{
                work(context);
                [context saveContextWithCompletion:completion];
            }];
        }
    }
}

- (void)saveInBackground:(void (^)(NSManagedObjectContext *context))work
              completion:(void (^)(BOOL savedChanges, NSError *error))completion
{
    [self saveInContext:self.backgroundContext
                   wait:NO
                   work:work
             completion:completion];
}

- (void)saveInBackgroundAndWait:(void (^)(NSManagedObjectContext *context))work
{
    [self saveInContext:self.backgroundContext
                   wait:YES
                   work:work
             completion:nil];
}

- (void)deleteAllDataWithCompletion:(void (^)(NSError*))completion
{
    [self saveInContext:self.backgroundContext
                   wait:NO
                   work:^(NSManagedObjectContext *localContext) {
                       NSArray *entityNames = [[self.managedObjectModel entities] valueForKey:@"name"];
                       for (NSString *entityName in entityNames) {
                           Class class = NSClassFromString(entityName);
                           [class deleteAllInContext:localContext];
                       }
                   } completion:^(BOOL contextDidSave, NSError *error) {
                       completion(error);
                   }];
}

#pragma mark - File Helpers
- (void)createDirectoryAtPath:(NSString*)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        return;
    }
    
    NSError* error;
    BOOL fileCreated = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
    if (!fileCreated) {
        NSLog(@"%@", error.localizedDescription);
        abort();
    }
}

+ (void)deleteStoreFilesForModelNamed:(NSString *)modelName
{
    NSURL *fileStoreURL = [self databaseURLForStoreName:modelName];
    NSURL *fileStoreShmURL = [NSURL URLWithString:[[fileStoreURL absoluteString] stringByAppendingString:@"-shm"]];
    NSURL *fileStoreWalURL = [NSURL URLWithString:[[fileStoreURL absoluteString] stringByAppendingString:@"-wal"]];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:fileStoreURL error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:fileStoreShmURL error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:fileStoreWalURL error:nil];
    
}

+ (NSURL*)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL*)databaseDirectory
{
    NSString* storeName = [self defaultStoreName];
    NSURL* applicationSupportDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [applicationSupportDirectory URLByAppendingPathComponent:storeName];
}

+ (NSURL*)databaseURLForStoreName:(NSString*)storeName
{
    NSURL* databaseDirectory = [self databaseDirectory];
    return [databaseDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", storeName]
                                              isDirectory:NO];
}

+ (NSString*)defaultStoreName
{
    NSString *storeName = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
    return storeName;
}

@end
