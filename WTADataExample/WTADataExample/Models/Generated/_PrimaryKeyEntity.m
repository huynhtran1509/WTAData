// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PrimaryKeyEntity.m instead.

#import "_PrimaryKeyEntity.h"

// These need to be implemented in your project parse data from/to json string
extern NSDate* (^dateFromString)(NSString* dateString, NSString* format);// if you get a link error, you need to implement this block
extern NSString* (^stringFromDate)(NSDate* date, NSString* format); // if you get a link error, you need to implement this block

const struct PrimaryKeyEntityAttributes PrimaryKeyEntityAttributes = {
	.customImportString = @"customImportString",
	.customPrimaryKey = @"customPrimaryKey",
	.data = @"data",
};

const struct PrimaryKeyEntityRelationships PrimaryKeyEntityRelationships = {
	.mergeAndPruneEntities = @"mergeAndPruneEntities",
	.mergeAndPruneSingleEntity = @"mergeAndPruneSingleEntity",
	.mergeEntities = @"mergeEntities",
	.mergeSingleEntity = @"mergeSingleEntity",
	.replaceEntities = @"replaceEntities",
	.replaceSingleEntity = @"replaceSingleEntity",
};

const struct PrimaryKeyEntityUserInfo PrimaryKeyEntityUserInfo = {
	.PrimaryAttribute = @"customPrimaryKey",
};

@implementation PrimaryKeyEntityID
@end

@implementation _PrimaryKeyEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PrimaryKeyEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PrimaryKeyEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PrimaryKeyEntity" inManagedObjectContext:moc_];
}

- (PrimaryKeyEntityID*)objectID {
	return (PrimaryKeyEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic customImportString;

@dynamic customPrimaryKey;

@dynamic data;

@dynamic mergeAndPruneEntities;

- (NSMutableSet*)mergeAndPruneEntitiesSet {
	[self willAccessValueForKey:@"mergeAndPruneEntities"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"mergeAndPruneEntities"];

	[self didAccessValueForKey:@"mergeAndPruneEntities"];
	return result;
}

@dynamic mergeAndPruneSingleEntity;

@dynamic mergeEntities;

- (NSMutableSet*)mergeEntitiesSet {
	[self willAccessValueForKey:@"mergeEntities"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"mergeEntities"];

	[self didAccessValueForKey:@"mergeEntities"];
	return result;
}

@dynamic mergeSingleEntity;

@dynamic replaceEntities;

- (NSMutableSet*)replaceEntitiesSet {
	[self willAccessValueForKey:@"replaceEntities"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"replaceEntities"];

	[self didAccessValueForKey:@"replaceEntities"];
	return result;
}

@dynamic replaceSingleEntity;

@end

