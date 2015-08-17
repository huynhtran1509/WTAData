// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Entity.h instead.

#import <CoreData/CoreData.h>

extern const struct EntityAttributes {
	__unsafe_unretained NSString *customDateAttribute;
	__unsafe_unretained NSString *dateAttribute;
	__unsafe_unretained NSString *epochDateAttribute;
	__unsafe_unretained NSString *stringAttribute;
} EntityAttributes;

@interface EntityID : NSManagedObjectID {}
@end

@interface _Entity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EntityID* objectID;

@property (nonatomic, strong) NSDate* customDateAttribute;

//- (BOOL)validateCustomDateAttribute:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateAttribute;

//- (BOOL)validateDateAttribute:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* epochDateAttribute;

//- (BOOL)validateEpochDateAttribute:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* stringAttribute;

//- (BOOL)validateStringAttribute:(id*)value_ error:(NSError**)error_;

@end

@interface _Entity (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCustomDateAttribute;
- (void)setPrimitiveCustomDateAttribute:(NSDate*)value;

- (NSDate*)primitiveDateAttribute;
- (void)setPrimitiveDateAttribute:(NSDate*)value;

- (NSDate*)primitiveEpochDateAttribute;
- (void)setPrimitiveEpochDateAttribute:(NSDate*)value;

- (NSString*)primitiveStringAttribute;
- (void)setPrimitiveStringAttribute:(NSString*)value;

@end

