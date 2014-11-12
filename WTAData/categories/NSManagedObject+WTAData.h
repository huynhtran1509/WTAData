//
//  NSManagedObject+WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (WTAData)

// Creates or updates the core data item represented by each dictionary in the array.
+ (NSArray *)importEntitiesFromArray:(NSArray *)array context:(NSManagedObjectContext *)context;

// Sets values for keys on the entity from the dictionary
- (void)importValuesForKeyWithDictionary:(NSDictionary *)dictionary;

// Returns the NSEntityDescription for this entity in the given context
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;

// Returns the entity's name as a string
+ (NSString *)entityName;

// Creates an instance of this entity in the given context
+ (instancetype)createEntityInContext:(NSManagedObjectContext *)context;

// Creates (or updates if checkExisting is YES) an entity from the given object
+ (instancetype)importEntityFromObject:(NSDictionary *)object context:(NSManagedObjectContext *)context checkExisting:(BOOL)checkExisting;

// Calls importEntityFromObject:context:checkExisting with checkExisting = YES
+ (instancetype)importEntityFromObject:(NSDictionary *)object context:(NSManagedObjectContext *)context;

//  Delete all entities
+ (void)truncateAllInContext:(NSManagedObjectContext *)context;

//  Delete all entities with a predicate
+ (void)truncateAllInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;

// Creates an NSAsynchronousFetchRequests with the given params for this entity
+ (NSAsynchronousFetchRequest *)asyncFetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors completion:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion;
+ (NSAsynchronousFetchRequest *)asyncFetchRequestWithPredicate:(NSPredicate *)predicate completion:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion;
+ (NSAsynchronousFetchRequest *)asyncFetchRequest:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion;

// Creates an NSFetchRequest with the given params for this entity
+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate;
+ (NSFetchRequest *)fetchRequest;

// Fetches all instances of this entity with the given params
+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context error:(NSError **)error;
+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate error:(NSError **)error;
+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error;

// Fetches first instance of this entity. nil if it does not exist
+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context error:(NSError **)error;
+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate error:(NSError **)error;
+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error;

+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context whereKey:(NSString *)key equalTo:(id)value error:(NSError **)error;

@end
