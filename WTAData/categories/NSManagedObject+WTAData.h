//
//  NSManagedObject+WTAData.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (WTAData)

// Returns the NSEntityDescription for this entity in the given context
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;

// Returns the entity's name as a string
+ (NSString *)entityName;

// Creates an instance of this entity in the given context
+ (instancetype)createEntityInContext:(NSManagedObjectContext *)context;

//  Delete all entities
+ (void)deleteAllInContext:(NSManagedObjectContext *)context;

//  Delete all entities with a predicate
+ (void)deleteAllInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;

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
+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context withAttribute:(NSString *)attribute equalTo:(id)value error:(NSError **)error;

// Fetches first instance of this entity. nil if it does not exist
+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context error:(NSError **)error;
+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate error:(NSError **)error;
+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error;
+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context withAttribute:(NSString *)attribute equalTo:(id)value error:(NSError **)error;

#if TARGET_OS_IPHONE
// Helper functions to return a NSFetchedResultsController.  Note that these functions only
// instantiate the controller and do not perform the first fetch.
+ (NSFetchedResultsController*)fetchControllerInContext:(NSManagedObjectContext *)context
                                              groupedBy:(NSString*)groupKey
                                          withPredicate:(NSPredicate*)predicate
                                        sortDescriptors:(NSArray*)sortDescriptors;


+ (NSFetchedResultsController*)fetchControllerInContext:(NSManagedObjectContext *)context
                                              groupedBy:(NSString*)groupKey
                                          withPredicate:(NSPredicate*)predicate
                                               sortedBy:(NSString*)key
                                              ascending:(BOOL)ascending;
#endif
@end
