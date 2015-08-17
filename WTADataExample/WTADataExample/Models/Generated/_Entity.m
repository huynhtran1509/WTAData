// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Entity.m instead.

#import "_Entity.h"

// These need to be implemented in your project parse data from/to json string
extern NSDate* (^dateFromString)(NSString* dateString, NSString* format);// if you get a link error, you need to implement this block
extern NSString* (^stringFromDate)(NSDate* date, NSString* format); // if you get a link error, you need to implement this block

const struct EntityAttributes EntityAttributes = {
	.customDateAttribute = @"customDateAttribute",
	.dateAttribute = @"dateAttribute",
	.epochDateAttribute = @"epochDateAttribute",
	.stringAttribute = @"stringAttribute",
};

@implementation EntityID
@end

@implementation _Entity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Entity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:moc_];
}

- (EntityID*)objectID {
	return (EntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic customDateAttribute;

@dynamic dateAttribute;

@dynamic epochDateAttribute;

@dynamic stringAttribute;

@end

