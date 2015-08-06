//
//  NSManagedObject+WTADataImport.h
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
 The WTADataImport category provides functions for importing dictionary model objects and arrays
 into the CoreData model.
 */

FOUNDATION_EXPORT NSString * const kRelationshipMergePolicyKey;
FOUNDATION_EXPORT NSString * const kMergePolicyMerge;

@interface NSManagedObject (WTADataImport)

/**
 Creates or updates the core data item represented by each dictionary in the array.  If the object
 model defines a primary key attribute and any item in the array may be missing that attribute, then
 no items will be imported.
 
 @param array an array of dictionaries representing the model objects to import.
 @param context the managed object context to import the objects into.
 
 @return an array of the imported NSManagedObjects
 */
+ (NSArray *)importEntitiesFromArray:(NSArray *)array context:(NSManagedObjectContext *)context;

/**
 Sets values for keys on the entity from the specified dictionary
 
 @param dictionary the dictionary containing the keys and values to update
 */
- (void)importValuesForKeyWithDictionary:(NSDictionary *)dictionary;

/**
 Creates (or updates if checkExisting is YES) an entity from the given object.
 
 @param object the dictionary containing the model object to import.
 @param context the context to import the object into
 @param checkExisting set to YES to check for and update an existing object, otherwise a new object
 will be created
 
 @return the created or updated NSManagedObject
 */
+ (nullable instancetype)importEntityFromObject:(NSDictionary *)object
                                        context:(NSManagedObjectContext *)context
                                  checkExisting:(BOOL)checkExisting;

/**
 Creates or updates an entity from the given object.  If the object already exists, it will be
 updated.
 
 @param object the dictionary containing the model object to import.
 @param context the context to import the object into
 
 @return the created or updated NSManagedObject
 */
+ (nullable instancetype)importEntityFromObject:(NSDictionary *)object
                                        context:(NSManagedObjectContext *)context;

@end

@interface NSDateFormatter (WTADataImport)

/**
 Default date format to use when import date objects.
 
 If no date format is defined in the user info of the entity then this format will be use.
 Defaults to @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"
 */
+ (NSString *)defaultImportDateFormat;

/**
 Sets defaultImportDateFormat - defaults to @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"
 */
+ (void)setDefaultImportDateFormat:(NSString *)defaultImportDateFormat;

@end

NS_ASSUME_NONNULL_END
