//
//  NSManagedObject+WTAData.m
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import "NSManagedObject+WTAData.h"
#import "NSEntityDescription+WTAData.h"

@implementation NSManagedObject (WTAData)


+ (void)deleteAllInContext:(NSManagedObjectContext *)context
{
    [self deleteAllInContext:context predicate:nil];
}

+ (void)deleteAllInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate
{
    NSArray *objects = [self fetchInContext:context predicate:predicate error:nil];
    for (NSManagedObject *object in objects)
    {
        [context deleteObject:object];
    }
}



+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
}

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

+ (instancetype)createEntityInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}


+ (NSAsynchronousFetchRequest *)asyncFetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors completion:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion
{
    NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:completion];
    return asyncRequest;
}

+ (NSAsynchronousFetchRequest *)asyncFetchRequestWithPredicate:(NSPredicate *)predicate completion:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion
{
    return [self asyncFetchRequestWithPredicate:predicate sortDescriptors:nil completion:completion];
}

+ (NSAsynchronousFetchRequest *)asyncFetchRequest:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion
{
    return [self asyncFetchRequestWithPredicate:nil completion:completion];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:predicate];
    [request setSortDescriptors:sortDescriptors];
    
    return request;
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
{
    return [self fetchRequestWithPredicate:predicate sortDescriptors:nil];
}

+ (NSFetchRequest *)fetchRequest
{
    return [self fetchRequestWithPredicate:nil];
}

+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [self fetchInContext:context predicate:nil error:error];
}

+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate error:(NSError **)error
{
    return [self fetchInContext:context predicate:predicate sortDescriptors:nil error:error];
}

+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error
{
    NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
    __block NSArray *results;
    
    [context performBlockAndWait:^{
        
        results = [context executeFetchRequest:request error:error];
        
    }];
    
    return results;
}

+ (NSArray *)fetchInContext:(NSManagedObjectContext *)context
                 withAttribute:(NSString *)attribute
                       equalTo:(id)value
                         error:(NSError *__autoreleasing *)error
{
    NSString *predicateFormat = [NSString stringWithFormat:@"%@ = %%@", attribute];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, value];
    return [self fetchInContext:context predicate:predicate error:error];
}

+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    return [[self fetchInContext:context predicate:nil error:error] firstObject];
}

+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate error:(NSError **)error
{
    return [[self fetchInContext:context predicate:predicate sortDescriptors:nil error:error] firstObject];
}

+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error
{
    return [[self fetchInContext:context predicate:predicate sortDescriptors:sortDescriptors error:error] firstObject];
}

+ (instancetype)fetchFirstInContext:(NSManagedObjectContext *)context withAttribute:(NSString *)attribute equalTo:(id)value error:(NSError *__autoreleasing *)error
{
    NSString *predicateFormat = [NSString stringWithFormat:@"%@ = %%@", attribute];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, value];
    return [self fetchFirstInContext:context predicate:predicate error:error];
}

+ (NSFetchedResultsController*)fetchControllerInContext:(NSManagedObjectContext *)context
                                              groupedBy:(NSString*)groupKey
                                          withPredicate:(NSPredicate*)predicate
                                        sortDescriptors:(NSArray*)sortDescriptors
{
    NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:context
                                                 sectionNameKeyPath:groupKey
                                                          cacheName:nil];
}


+ (NSFetchedResultsController*)fetchControllerInContext:(NSManagedObjectContext *)context
                                              groupedBy:(NSString*)groupKey
                                          withPredicate:(NSPredicate*)predicate
                                               sortedBy:(NSString*)key
                                              ascending:(BOOL)ascending
{
    NSSortDescriptor *sortdescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    
    return [self fetchControllerInContext:context
                                groupedBy:groupKey
                            withPredicate:predicate
                          sortDescriptors:@[sortdescriptor]];
}


@end
