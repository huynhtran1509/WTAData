// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RelationshipEntity.m instead.

#import "_RelationshipEntity.h"

// These need to be implemented in your project parse data from/to json string
extern NSDate* (^dateFromString)(NSString* dateString, NSString* format);// if you get a link error, you need to implement this block
extern NSString* (^stringFromDate)(NSDate* date, NSString* format); // if you get a link error, you need to implement this block

const struct RelationshipEntityAttributes RelationshipEntityAttributes = {
	.primaryKey = @"primaryKey",
	.testString = @"testString",
};

const struct RelationshipEntityRelationships RelationshipEntityRelationships = {
	.mergeAndPruneParent = @"mergeAndPruneParent",
	.mergeParent = @"mergeParent",
	.replaceParent = @"replaceParent",
	.singleMergeAndPruneParent = @"singleMergeAndPruneParent",
	.singleMergeParent = @"singleMergeParent",
	.singleReplaceParent = @"singleReplaceParent",
};

const struct RelationshipEntityUserInfo RelationshipEntityUserInfo = {
	.PrimaryAttribute = @"primaryKey",
};

@implementation RelationshipEntityID
@end

@implementation _RelationshipEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RelationshipEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RelationshipEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RelationshipEntity" inManagedObjectContext:moc_];
}

- (RelationshipEntityID*)objectID {
	return (RelationshipEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"primaryKeyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"primaryKey"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic primaryKey;

- (int64_t)primaryKeyValue {
	NSNumber *result = [self primaryKey];
	return [result longLongValue];
}

- (void)setPrimaryKeyValue:(int64_t)value_ {
	[self setPrimaryKey:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitivePrimaryKeyValue {
	NSNumber *result = [self primitivePrimaryKey];
	return [result longLongValue];
}

- (void)setPrimitivePrimaryKeyValue:(int64_t)value_ {
	[self setPrimitivePrimaryKey:[NSNumber numberWithLongLong:value_]];
}

@dynamic testString;

@dynamic mergeAndPruneParent;

@dynamic mergeParent;

@dynamic replaceParent;

@dynamic singleMergeAndPruneParent;

@dynamic singleMergeParent;

@dynamic singleReplaceParent;

@end

