// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PrimaryKeyEntity.h instead.

#import <CoreData/CoreData.h>

extern const struct PrimaryKeyEntityAttributes {
	__unsafe_unretained NSString *customImportString;
	__unsafe_unretained NSString *customPrimaryKey;
	__unsafe_unretained NSString *data;
} PrimaryKeyEntityAttributes;

extern const struct PrimaryKeyEntityRelationships {
	__unsafe_unretained NSString *mergeAndPruneEntities;
	__unsafe_unretained NSString *mergeAndPruneSingleEntity;
	__unsafe_unretained NSString *mergeEntities;
	__unsafe_unretained NSString *mergeSingleEntity;
	__unsafe_unretained NSString *replaceEntities;
	__unsafe_unretained NSString *replaceSingleEntity;
} PrimaryKeyEntityRelationships;

extern const struct PrimaryKeyEntityUserInfo {
	__unsafe_unretained NSString *PrimaryAttribute;
} PrimaryKeyEntityUserInfo;

@class RelationshipEntity;
@class RelationshipEntity;
@class RelationshipEntity;
@class RelationshipEntity;
@class RelationshipEntity;
@class RelationshipEntity;

@interface PrimaryKeyEntityID : NSManagedObjectID {}
@end

@interface _PrimaryKeyEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PrimaryKeyEntityID* objectID;

@property (nonatomic, strong) NSString* customImportString;

//- (BOOL)validateCustomImportString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* customPrimaryKey;

//- (BOOL)validateCustomPrimaryKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* data;

//- (BOOL)validateData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *mergeAndPruneEntities;

- (NSMutableSet*)mergeAndPruneEntitiesSet;

@property (nonatomic, strong) RelationshipEntity *mergeAndPruneSingleEntity;

//- (BOOL)validateMergeAndPruneSingleEntity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *mergeEntities;

- (NSMutableSet*)mergeEntitiesSet;

@property (nonatomic, strong) RelationshipEntity *mergeSingleEntity;

//- (BOOL)validateMergeSingleEntity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *replaceEntities;

- (NSMutableSet*)replaceEntitiesSet;

@property (nonatomic, strong) RelationshipEntity *replaceSingleEntity;

//- (BOOL)validateReplaceSingleEntity:(id*)value_ error:(NSError**)error_;

@end

@interface _PrimaryKeyEntity (MergeAndPruneEntitiesCoreDataGeneratedAccessors)
- (void)addMergeAndPruneEntities:(NSSet*)value_;
- (void)removeMergeAndPruneEntities:(NSSet*)value_;
- (void)addMergeAndPruneEntitiesObject:(RelationshipEntity*)value_;
- (void)removeMergeAndPruneEntitiesObject:(RelationshipEntity*)value_;

@end

@interface _PrimaryKeyEntity (MergeEntitiesCoreDataGeneratedAccessors)
- (void)addMergeEntities:(NSSet*)value_;
- (void)removeMergeEntities:(NSSet*)value_;
- (void)addMergeEntitiesObject:(RelationshipEntity*)value_;
- (void)removeMergeEntitiesObject:(RelationshipEntity*)value_;

@end

@interface _PrimaryKeyEntity (ReplaceEntitiesCoreDataGeneratedAccessors)
- (void)addReplaceEntities:(NSSet*)value_;
- (void)removeReplaceEntities:(NSSet*)value_;
- (void)addReplaceEntitiesObject:(RelationshipEntity*)value_;
- (void)removeReplaceEntitiesObject:(RelationshipEntity*)value_;

@end

@interface _PrimaryKeyEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCustomImportString;
- (void)setPrimitiveCustomImportString:(NSString*)value;

- (NSString*)primitiveCustomPrimaryKey;
- (void)setPrimitiveCustomPrimaryKey:(NSString*)value;

- (NSString*)primitiveData;
- (void)setPrimitiveData:(NSString*)value;

- (NSMutableSet*)primitiveMergeAndPruneEntities;
- (void)setPrimitiveMergeAndPruneEntities:(NSMutableSet*)value;

- (RelationshipEntity*)primitiveMergeAndPruneSingleEntity;
- (void)setPrimitiveMergeAndPruneSingleEntity:(RelationshipEntity*)value;

- (NSMutableSet*)primitiveMergeEntities;
- (void)setPrimitiveMergeEntities:(NSMutableSet*)value;

- (RelationshipEntity*)primitiveMergeSingleEntity;
- (void)setPrimitiveMergeSingleEntity:(RelationshipEntity*)value;

- (NSMutableSet*)primitiveReplaceEntities;
- (void)setPrimitiveReplaceEntities:(NSMutableSet*)value;

- (RelationshipEntity*)primitiveReplaceSingleEntity;
- (void)setPrimitiveReplaceSingleEntity:(RelationshipEntity*)value;

@end

