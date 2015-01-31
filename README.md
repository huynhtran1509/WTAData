WTAData
=======

WTAData provides a light-weight interface for setting up an asynchronous CoreData stack. WTAData utilizes two NSManagedObjectContexts: main and background, for achieving fast and performant core data access.  The main context is generally used for read access to the core data stack.  The main context updates automatically when changes are saved by the background managed object context.  The background context is primarily used for performing saves in background threads, such as when a network call completes.

## Setup

Setting up a default stack supporting CoreData automigration by providing WTAData with your Core Data model.

`WTAData *data = [[WTAData alloc] initWithModelNamed:@"WTADataExample"];`

Once the stack is created, the stack is ready to go.  In additon to the default initialization, WTAData provides some additional initializers for speciifc use-cases as shown below.

````
// Initialize and delete the store on a model mis-match
[[WTAData alloc] initWithModelNamed:@"WTADataExample" deleteOnModelMismatch:YES];

// Initialize and verify the store and delete the store on a model mis-match
[[WTAData alloc] initWithModelNamed:@"WTADataExample" deleteOnModelMismatch:YES verifyStoreIntegrity:YES];

// Create an in-memory store
[[WTAData alloc] initInMemoryStackWithModelNamed];
`````
