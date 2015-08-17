// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RelationshipEntity.h instead.

#import <CoreData/CoreData.h>

extern const struct RelationshipEntityAttributes {
	__unsafe_unretained NSString *primaryKey;
	__unsafe_unretained NSString *testString;
} RelationshipEntityAttributes;

extern const struct RelationshipEntityRelationships {
	__unsafe_unretained NSString *mergeAndPruneParent;
	__unsafe_unretained NSString *mergeParent;
	__unsafe_unretained NSString *replaceParent;
	__unsafe_unretained NSString *singleMergeAndPruneParent;
	__unsafe_unretained NSString *singleMergeParent;
	__unsafe_unretained NSString *singleReplaceParent;
} RelationshipEntityRelationships;

extern const struct RelationshipEntityUserInfo {
	__unsafe_unretained NSString *PrimaryAttribute;
} RelationshipEntityUserInfo;

@class PrimaryKeyEntity;
@class PrimaryKeyEntity;
@class PrimaryKeyEntity;
@class PrimaryKeyEntity;
@class PrimaryKeyEntity;
@class PrimaryKeyEntity;

@interface RelationshipEntityID : NSManagedObjectID {}
@end

@interface _RelationshipEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RelationshipEntityID* objectID;

@property (nonatomic, strong) NSNumber* primaryKey;

@property (atomic) int64_t primaryKeyValue;
- (int64_t)primaryKeyValue;
- (void)setPrimaryKeyValue:(int64_t)value_;

//- (BOOL)validatePrimaryKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* testString;

//- (BOOL)validateTestString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) PrimaryKeyEntity *mergeAndPruneParent;

//- (BOOL)validateMergeAndPruneParent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) PrimaryKeyEntity *mergeParent;

//- (BOOL)validateMergeParent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) PrimaryKeyEntity *replaceParent;

//- (BOOL)validateReplaceParent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) PrimaryKeyEntity *singleMergeAndPruneParent;

//- (BOOL)validateSingleMergeAndPruneParent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) PrimaryKeyEntity *singleMergeParent;

//- (BOOL)validateSingleMergeParent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) PrimaryKeyEntity *singleReplaceParent;

//- (BOOL)validateSingleReplaceParent:(id*)value_ error:(NSError**)error_;

@end

@interface _RelationshipEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitivePrimaryKey;
- (void)setPrimitivePrimaryKey:(NSNumber*)value;

- (int64_t)primitivePrimaryKeyValue;
- (void)setPrimitivePrimaryKeyValue:(int64_t)value_;

- (NSString*)primitiveTestString;
- (void)setPrimitiveTestString:(NSString*)value;

- (PrimaryKeyEntity*)primitiveMergeAndPruneParent;
- (void)setPrimitiveMergeAndPruneParent:(PrimaryKeyEntity*)value;

- (PrimaryKeyEntity*)primitiveMergeParent;
- (void)setPrimitiveMergeParent:(PrimaryKeyEntity*)value;

- (PrimaryKeyEntity*)primitiveReplaceParent;
- (void)setPrimitiveReplaceParent:(PrimaryKeyEntity*)value;

- (PrimaryKeyEntity*)primitiveSingleMergeAndPruneParent;
- (void)setPrimitiveSingleMergeAndPruneParent:(PrimaryKeyEntity*)value;

- (PrimaryKeyEntity*)primitiveSingleMergeParent;
- (void)setPrimitiveSingleMergeParent:(PrimaryKeyEntity*)value;

- (PrimaryKeyEntity*)primitiveSingleReplaceParent;
- (void)setPrimitiveSingleReplaceParent:(PrimaryKeyEntity*)value;

@end

