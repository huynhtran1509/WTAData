//
//  NSManagedObject+WTADataImport.h
//  WTAData
//
//  Copyright (c) 2014 WillowTreeApps. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (WTADataImport)

// Creates or updates the core data item represented by each dictionary in the array.
+ (NSArray *)importEntitiesFromArray:(NSArray *)array context:(NSManagedObjectContext *)context;

// Sets values for keys on the entity from the dictionary
- (void)importValuesForKeyWithDictionary:(NSDictionary *)dictionary;

// Creates (or updates if checkExisting is YES) an entity from the given object
+ (instancetype)importEntityFromObject:(NSDictionary *)object context:(NSManagedObjectContext *)context checkExisting:(BOOL)checkExisting;

// Calls importEntityFromObject:context:checkExisting with checkExisting = YES
+ (instancetype)importEntityFromObject:(NSDictionary *)object context:(NSManagedObjectContext *)context;

@end
