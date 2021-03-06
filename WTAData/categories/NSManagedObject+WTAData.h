//
//  NSManagedObject+WTAData.h
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


// Nullability Annotations were added in Xcode 6.3. The following #defines are required for
// backwards compatability.
#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define nullable
#define __nullable
#define nonnull
#endif


NS_ASSUME_NONNULL_BEGIN

/**
 The WTAData NSManagedObject category provides simplified helpers for creating, deleting,
 and fetching managed objects.
 */
@interface NSManagedObject (WTAData)

/**
 Returns the entity description of the given object in the specified context.
 
 @param context the managed object context to use
 
 @return the entity description
 */
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;

/**
 Returns the entity name of the managed object.
 
 @return the entity name of the object
 */
+ (NSString *)entityName;

/**
 Creates an instance of the entity in the specified context.
 
 @param context the managed object context to create the entity in
 
 @return an instance of the created entity
 */
+ (instancetype)createEntityInContext:(NSManagedObjectContext *)context;

/**
 Deletes all entities from the specified object context.
 
 @param context the managed object context to delete objects from
 */
+ (void)deleteAllInContext:(NSManagedObjectContext *)context;

/**
 Deletes all entities from the specified object context that match the specified predicate.
 
 @param context the managed object context to delete objects from
 @param predicate the predicate to match when deleting objects
 */
+ (void)deleteAllInContext:(NSManagedObjectContext *)context predicate:(nullable NSPredicate *)predicate;

/**
 Returns another NSManagedObject instance that is within a different NSManagedObjectContext.
 
 @param otherContext the context the returned NSManagedObject instance will be contained in, or nil if it doesn't exit or there was an error.
  */
- (instancetype)inContext:(NSManagedObjectContext *)otherContext error:(NSError**)error;

/**
 Returns count of entities of a given type in a NSManagedObjectContext.
  */
+ (NSUInteger)countWithContext:(NSManagedObjectContext *)context error:(NSError**)error;

/**
 Returns count of entities of a given, in a NSManagedObjectContext, that pass a speified searchFilter.
 */
+ (NSUInteger)countOfEntitiesWithPredicate:(nullable NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context  error:(NSError**)error;

/**
 Creates a NSAsynchronousFetchRequests with the specified predicate, sort descriptor, and completion
 block.
 
 @param predicate predicate used in the fetch request
 @param sortDescriptors an array of sort descriptors used to sort the results
 @param completion completion block called when the fetch request is completed
 
 @return the NSAsynchronousFetchRequest for the entity
 */
+ (NSAsynchronousFetchRequest *)asyncFetchRequestWithPredicate:(nullable NSPredicate *)predicate
                                               sortDescriptors:(nullable NSArray *)sortDescriptors
                                                    completion:(nullable NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion;

/**
 Creates a NSAsynchronousFetchRequests with the specified predicate and completion block.
 
 @param predicate predicate used in the fetch request
 @param completion completion block called when the fetch request is completed
 
 @return the NSAsynchronousFetchRequest for the entity
 */
+ (NSAsynchronousFetchRequest *)asyncFetchRequestWithPredicate:(nullable NSPredicate *)predicate
                                                    completion:(nullable NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion;

/**
 Creates a NSAsynchronousFetchRequest to fetch all entities of this type.
 
 @param completion completion block called when the fetch request is completed
 
 @return the NSAsynchronousFetchRequest for the entity
 */
+ (NSAsynchronousFetchRequest *)asyncFetchRequest:(nullable NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion;

/**
 Creates a NSFetchRequest with the specified predicate and sort descriptors
 
 @param predicate predicate used in the fetch request
 @param sortDescriptors an array of sort descriptors used to sort the results
 
 @return the NSFetchRequest for the entity
 */
+ (NSFetchRequest *)fetchRequestWithPredicate:(nullable NSPredicate *)predicate
                              sortDescriptors:(nullable NSArray *)sortDescriptors;

/**
 Creates a NSFetchRequest with the specified predicate.
 
 @param predicate predicate used in the fetch request
 
 @return the NSFetchRequest for the entity
 */
+ (NSFetchRequest *)fetchRequestWithPredicate:(nullable NSPredicate *)predicate;

/**
 Creates a NSFetchRequest for all of the current entity types.
 
 @return the NSFetchRequest for the entity
 */
+ (NSFetchRequest *)fetchRequest;

/**
 Fetches all managed objects of the current entity type in the specified context.
 
 @param context the context to fetch the entities from
 @param error an NSError if the fetch failed, nil otherwise
 
 @return an array of managed objects.
 */
+ (nullable NSArray *)fetchInContext:(NSManagedObjectContext *)context error:(NSError **)error;

/**
 Fetches all managed objects of the current entity type in the specified context that match the
 given predicate
 
 @param context the context to fetch the entities from
 @param predicate the predicate to match when fetching objects
 @param error an NSError if the fetch failed, nil otherwise
 
 @return an array of managed objects
 */
+ (nullable NSArray *)fetchInContext:(NSManagedObjectContext *)context
                           predicate:(nullable NSPredicate *)predicate
                               error:(NSError **)error;

/**
 Fetches all managed objects of the current entity type in the specified context that match the
 given predicate and that are sorted by the specified sort descriptors.
 
 @param context the context to fetch the entities from
 @param predicate the predicate to match when fetching objects
 @param sortDescriptors an array of sort descriptors
 @param error an NSError if the fetch failed, nil otherwise
 
 @return an array of sorted managed objects.
 */
+ (nullable NSArray *)fetchInContext:(NSManagedObjectContext *)context
                           predicate:(nullable NSPredicate *)predicate
                     sortDescriptors:(nullable NSArray *)sortDescriptors
                               error:(NSError **)error;

/**
 Fetches all managed objects of the current entity type in the specified context that have a
 specified attribute value.
 
 @param context the context to fetch the entities in
 @param attribute the attribute to match
 @param value the attribute value to match
 @param error an NSError if the fetch failed, nil otherwise
 
 @return an array of managed objects.
 */
+ (nullable NSArray *)fetchInContext:(NSManagedObjectContext *)context
                       withAttribute:(NSString *)attribute
                             equalTo:(id)value
                               error:(NSError **)error;

/**
 Fetches the first entity of the current type in the specified context.
 
 @param context the context to use with the fetch
 @param error an NSError if the fetch failed, nil otherwise
 
 @return the first managed object or nil if no object is found
 */
+ (nullable instancetype)fetchFirstInContext:(NSManagedObjectContext *)context
                                       error:(NSError **)error;

/**
 Fetches the first entity of the current type in the specified context.
 
 @param context the context to use with the fetch
 @param predicate the predicate to match
 @param error an NSError if the fetch failed, nil otherwise
 
 @return the first managed object or nil if no object is found
 */
+ (nullable instancetype)fetchFirstInContext:(NSManagedObjectContext *)context
                                   predicate:(nullable NSPredicate *)predicate
                                       error:(NSError **)error;

/**
 Fetches the first entity of the current type in the specified context from the items that match
 the specified predicate and sorted by the sort descriptors.
 
 @param context the context to use with the fetch
 @param predicate the predicate to match
 @param sortDescriptors an array of sort descriptors to sort the items with
 @param error an NSError if the fetch failed, nil otherwise
 
 @return the first managed object or nil if no object is found
 */
+ (nullable instancetype)fetchFirstInContext:(NSManagedObjectContext *)context
                                   predicate:(nullable NSPredicate *)predicate
                             sortDescriptors:(nullable NSArray *)sortDescriptors
                                       error:(NSError **)error;

/**
 Fetches the first entity of the current type in the specified context.
 
 @param context the context to use with the fetch
 @param error an NSError if the fetch failed, nil otherwise
 
 @return the first managed object or nil if no object is found
 */
+ (nullable instancetype)fetchFirstInContext:(NSManagedObjectContext *)context
                               withAttribute:(NSString *)attribute
                                     equalTo:(id)value
                                       error:(NSError **)error;

/**
 Creates a NSFetchedResultsController in the specified context.
 
 @param context the context to use with the fetched results controller
 @param groupKey the key to use to group items
 @param predicate the predicate to match when fetching objects
 @param sortDescriptors an array of sort descriptors to use for sorting fetched items.
 
 @return an initialized NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchControllerInContext:(NSManagedObjectContext *)context
                                               groupedBy:(nullable NSString *)groupKey
                                           withPredicate:(nullable NSPredicate *)predicate
                                         sortDescriptors:(nullable NSArray *)sortDescriptors;

/**
 Creates a NSFetchedResultsController in the specified context.
 
 @param context the context to use with the fetched results controller
 @param groupKey the key to use to group items
 @param predicate the predicate to match when fetching objects
 @param key the key to use when sorting
 @param ascending specify YES to sort by ascending key values
 
 @return an initialized NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchControllerInContext:(NSManagedObjectContext *)context
                                               groupedBy:(nullable NSString *)groupKey
                                           withPredicate:(nullable NSPredicate *)predicate
                                                sortedBy:(nullable NSString *)key
                                               ascending:(BOOL)ascending;

@end

NS_ASSUME_NONNULL_END
