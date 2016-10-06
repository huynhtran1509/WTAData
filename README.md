WTAData
=======
[![Build Status](https://travis-ci.org/willowtreeapps/WTAData.svg?branch=develop)](https://travis-ci.org/willowtreeapps/WTAData?branch=develop)

*** Important Note iOS 10 or later ***

*As of iOS 10, Apple has provided the NSPersistentContainer class for managing the setup of core data stacks. This should be the preferred method of setting up a stack going forward and no new development is planned for WTAData.*

*To set up this kind of stack, you simply create an NSPersistentContainer as shown in the following code snippet.*
```swift
let container = NSPersistentContainer(name: "iOS10CoreData")
container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        // TODO: Appropriate error handling here.
})
container.viewContext.automaticallyMergesChangesFromParent = true
```

*Saving your managed objects in the background is then as simple as*

```swift
container.performBackgroundTask { (context) in
    guard let entityName = Entity.entity().name else {
        return
    }

    let row = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Entity

    // Modify object before saving here.

    do {
        try context.save()
    } catch {
        // TODO: Handle save error.
    }
}
```

*Additional documentation can be found here https://developer.apple.com/reference/coredata/nspersistentcontainer*

WTAData provides a light-weight interface for setting up an asynchronous CoreData stack. WTAData utilizes two NSManagedObjectContexts: main and background, for achieving fast and performant core data access.  The main context is generally used for read access to the core data stack.  The main context updates automatically when changes are saved by the background managed object context.  The background context is primarily used for performing saves in background threads, such as when a network call completes.

## Setup

Setting up a default stack supporting CoreData automigration by providing WTAData with your Core Data model.

```objc
WTAData *data = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];
```

Once the stack is created, the stack is ready to go.  In additon to the default initialization, WTAData provides some additional initializers for speciifc use-cases as shown below.

```objc
// Initialize a new configuration
WTADataConfiguration *configuration = [WTADataConfiguration defaultConfigurationWithModelNamed:@"WTADataExample"];

// Set flag for deleting the store on a model mis-match
[configuration setShouldDeleteStoreFileOnModelMismatch:YES];

// Set flag for deleting the store on sql integrity errors
[configuration setShouldDeleteStoreFileOnIntegrityErrors:YES];

// Set flag for using an in-memory store
[configuration setShouldUseInMemoryStore:YES];

[[WTAData alloc] initWithConfiguration:configuration];
```

## Fetching Entities

Fetching entities from the store is easy using the categories provided by WTAData on NSManagedObjects

```objc
NSError *error = nil;
WTAData *data = <initialized stack>
[ManagedObject fetchInContext:data.mainContext error:&error];
```

See additional helpers in [NSManagedObject+WTAData.h](./WTAData/categories/NSManagedObject+WTAData.h) for more information.

## Saving data

WTAData provides simple mechanisms for saving and creating data in the background.  For example, saving new items in the background is as simple as the following lines of code.

```objc
[self.data saveInBackground:^(NSManagedObjectContext *context) {
    Entity *entity = [Entity createEntityInContext:context];
    entity.stringAttribute = [NSString stringWithFormat:@"Entity Created"];
} completion:^(BOOL savedChanges, NSError *error) {
    NSLog(@"Changes saved %d with error %@", savedChanges, error);
}];
```

## Importing JSON Objects

WTAData provides a set of import categories that help streamline importing JSON objects directly
into Core Data. The import functions are specified in [NSManagedObject+WTADataImport.h](./WTAData/categories/NSManagedObject+WTADataImport.h) and define
functionality such as importing an array of JSON items or importing a single item. The import
functions also support importing relationships and will also use the import functionality on
objects in the relationship.

### Configuring Object Models for import

WTAData provides the ability to customize and configure your JSON import by specifying key-value pairs
in the UserInfo dictionary in the managed object model. WTAData will by default map your keys in the JSON dictionary to the property names in the NSManagedObject. For  example, a key named 'data' in the JSON dictionary would set the 'data' property of your NSManagedObject.

#### Custom JSON Key mapping

A custom JSON key mapping can be made by adding the 'ImportName' key-value pair on an attribute and specifying the name of the JSON key. For example, the JSON key
'age_level' could be imported to the 'ageLevel' object property by specifying {ImportName: age_level}.

#### Specifying Primary key

You can specify the primary key in the JSON to map to the primary key in your model.  This is done by
adding the key 'PrimaryAttribute' to the entity's user info dictionary and setting the value to the name
of the attribute that should be used for the primary key.

Alternatively, if your entity specifies an attribute of the format '(entityName)ID', then if the JSON contains
the same key, then that value will be used as the primary attribute.

#### Specifying Custom Date Formats

WTAData defaults to using the ISO8601 format string of 'yyyy-MM-dd'T'HH:mm:ssZZZZZ' for date strings in JSON.
You can customize this format by specifying the key 'DateFormat' and passing a date format string as the value on the attribute

#### Relationships and Import Behavior

Relationships pose an interesting challenge when importing, because there may be entities in a relationship
that should no longer be part of the relationship or there may be cases where data needs to be merged when
importing a JSON dictionary. WTAData provides custom merge policies when importing relationships that covers most common use cases. These are specified on the relationship using the 'MergePolicy' key and setting to one of the following values:

**'Replace' - Replace Relationship Policy (DEFAULT)**

The default policy for relationship imports.  If a custom merge policy is not specified, this is the one that is used. All existing relationship items are removed and replaced with the JSON items.

**'Merge' - Merge Relationship Policy**

Updates any existing objects found in the relationships based on the primary key. This policy does not delete any objects.

**'MergeAndPrune' - Merge and Prune Relationship Policy**

Updates any existing objects found in the relationships based on the primary key. Any items not in the import set will be pruned from the relationship set.

#### Import Key List

<table>
    <tr>
        <td>**Key**</td>
        <td>**Element**</td>
        <td>**Values**</td>
        <td>**Description**</td>
    </tr>
    <tr>
        <td>ImportName</td>
        <td>Attribute or Relationship</td>
        <td>Name of JSON Key this attribute maps to</td>
        <td>Allows specification of JSON key to NSManagedObject property.</td>
    </tr>
    <tr>
        <td>PrimaryKey</td>
        <td>Entity</td>
        <td>Name of the entity's primary key</td>
        <td>Allows specification of primary key to use for import.</td>
    </tr>
    <tr>
        <td>DateFormat</td>
        <td>Attribute</td>
        <td>NSDate date format string</td>
        <td>Allows specification of custom date format to use when importing a date from string.</td>
    </tr>
    <tr>
        <td>MergePolicy</td>
        <td>Relationship</td>
        <td>Replace, Merge, or MergeAndPrune</td>
        <td>Allows specification of merge logic. Descriptions [here](# Relationships and Import Behavior)</td>
    </tr>
</table>

### Importing Objects

There are 2 main imports used with WTAData, one for importing an array of JSON objects and one for importing a single object. Examples of these two are shown below:

```objc

// Single entity import
PrimaryKeyEntity *entity = [PrimaryKeyEntity importEntityFromObject:entityWithDataContent
                                                            context:self.wtaData.mainContext];

// Array import
NSArray *importedObjects = [PrimaryKeyEntity importEntitiesFromArray:objectArray];
                                                            context:self.wtaData.mainContext];
```

Additional import methods are defined in [NSManagedObject+WTADataImport.h](./WTAData/categories/NSManagedObject+WTADataImport.h)
