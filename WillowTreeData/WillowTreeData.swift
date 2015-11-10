//
//  WillowTreeData.swift
//  WillowTreeCoreDataExample
//
//  Created by Robert Thompson on 9/17/15.
//  Copyright © 2015 Robert S. Thompson. All rights reserved.
//

import Foundation
import CoreData

///  This struct is used to initialize a DataController object.
public struct PersistentStore : CustomStringConvertible
{
    public let storeType: String
    public let URL: NSURL
    public let configuration: String?
    public let options: [NSObject : AnyObject]?
    public let autoMigrating: Bool

    /**
    Initializer for PersistentStore struct
    
    - parameter storeType:     This is the type of NSPersistentStore you want to create. Examples include NSSQLiteStoreType (the default), NSInMemoryStore, and others.
    - parameter URL:           The URL for the peristent store. Required, but might be unused depending on the store type (an in-memory store doesn't actually save anything to disk)
    - parameter configuration: The configuration corresponding to this store. Usually nil, but has it's uses. See the model editory.
    - parameter options:       Standard persistent store options dictionary, this also varies based on type of store
    - parameter autoMigrating: Send true to have this store handle migration automatically. Defaults to false.
    
    - returns: A PersistentStore structure suitable for use in initializing a DataController
    */
    public init(
        storeType: String = NSSQLiteStoreType,
        URL: NSURL = getDocumentURLForFilename("Data.sqlite"),
        configuration: String? = nil,
        options: [NSObject : AnyObject]? = nil,
        autoMigrating: Bool = false
        )
    {
        self.storeType = storeType
        self.URL = URL
        self.configuration = configuration
        var newOptions = options ?? [:]
        if autoMigrating
        {
            newOptions[NSInferMappingModelAutomaticallyOption] = true
            newOptions[NSMigratePersistentStoresAutomaticallyOption] = true
        }
        else if (newOptions[NSMigratePersistentStoresAutomaticallyOption] == nil)
        {
            newOptions[NSInferMappingModelAutomaticallyOption] = false
            newOptions[NSMigratePersistentStoresAutomaticallyOption] = false
        }
        self.options = newOptions
        self.autoMigrating = autoMigrating
    }
    
    public var description: String {
        get {
            let none = "None"
            return "{\nstoreType: \(storeType)\nURL: \(URL)\nconfiguration: \(configuration ?? none)\noptions: \(options?.description ?? none)\n}"
        }
    }
}

/// The clearing-house for all things data-related.
public class DataController
{
    private let _context: NSManagedObjectContext
    private let savingContext: NSManagedObjectContext
    
    /// Main-queue context
    public final var context: NSManagedObjectContext {
        get {
            return _context
        }
    }
    
    /**
    DataController initializer.
    
    - parameter persistentStores: An array of PersistentStore structs. These will be added to the persistent store coordinator in the order they're passed in. They are added on a background queue, so may not be available immediately.
    
    - returns: An initialized DataController.
    */
    required public init(persistentStores: [PersistentStore] = [PersistentStore()])
    {
        guard let mom = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle()]) else
        {
            fatalError("Could not create managed object model")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        savingContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        savingContext.persistentStoreCoordinator = psc
        
        _context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        _context.parentContext = savingContext
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {

            for store in persistentStores
            {
                guard let _ = try? psc.addPersistentStoreWithType(store.storeType, configuration: store.configuration, URL: store.URL, options: store.options) else
                {
                    fatalError("Failed to add a persistent store to the coordinator. The store was \(store)")
                }
            }
        }
    }
}

public extension DataController
{
    /**
    This method always runs on the main thread, regardless of which thread you called it from. You
    asked to save, so you should expect the hit. Note that the actual save-to-disk part does happen on a 
    background queue, so the hit will be very small!
    */
    public func save() throws {
        
        if NSThread.currentThread() != NSThread.mainThread()
        {
            var error: ErrorType? = nil

            dispatch_sync(dispatch_get_main_queue()) {
                do {
                    try self.save()
                } catch let blockError {
                    error = blockError
                }
            }
            
            if error != nil {
                throw error!
            }
        }
        
        if context.hasChanges
        {
            try self.context.save()
        }
        
        guard let parentContext = self.context.parentContext else { return }
        
        parentContext.performBlock {
            guard parentContext.hasChanges else { return }
            
            do {
                try parentContext.save()
            } catch let error as NSError {
                fatalError("Error saving data that had already been saved! \(error)\n\(error.userInfo)")
            }
        }
    }
}

private func getDocumentURLForFilename(filename: String) -> NSURL
{
    let fileManager = NSFileManager.defaultManager()
    guard let url = try? fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false) else {
        // if the Document directory doesn't exist, things have gone off the deep end
        fatalError("No Document directory found!")
    }
    
    let fileURL = url.URLByAppendingPathComponent(filename)
    
    return fileURL
}

