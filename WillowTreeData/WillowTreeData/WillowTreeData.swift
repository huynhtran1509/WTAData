//
//  WillowTreeData.swift
//  WillowTreeCoreDataExample
//
//  Created by Robert Thompson on 9/17/15.
//  Copyright © 2015 Robert S. Thompson. All rights reserved.
//

import Foundation
import CoreData

public struct PersistentStore : CustomStringConvertible
{
    public let storeType: String
    public let URL: NSURL
    public let configuration: String?
    public let options: [NSObject : AnyObject]?
    public let autoMigrating: Bool

    public init(storeType: String = NSSQLiteStoreType, URL: NSURL = getDocumentURLForFilename("Data.sqlite"), configuration: String? = nil, options: [NSObject : AnyObject]? = nil, autoMigrating: Bool = false)
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

public class DataController
{
    private let _context: NSManagedObjectContext
    private let savingContext: NSManagedObjectContext
    
    public var context: NSManagedObjectContext {
        get {
            return _context
        }
    }
    
    public init(persistentStores: [PersistentStore] = [PersistentStore()])
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
    public func save() {
        if NSThread.currentThread() != NSThread.mainThread()
        {
            dispatch_sync(dispatch_get_main_queue()) {
                self.save()
            }
        }
        
        if context.hasChanges
        {
            do {
                try self.context.save()
            }
            catch let error as NSError {
                print("Error saving: \(error.localizedDescription)\n\(error.userInfo)")
                abort()
            }
        }
        
        guard let parentContext = self.context.parentContext else { return }
        
        parentContext.performBlock {
            guard parentContext.hasChanges else { return }
            
            do
            {
                try parentContext.save()
            }
            catch let error as NSError
            {
                print("error saving: \(error.localizedDescription)\n\(error.userInfo)")
                abort() // if we got here, then saving this same data worked above so we shouldn't be able to get here
            }
        }
    }
}

public func getDocumentURLForFilename(filename: String) -> NSURL
{
    let fileManager = NSFileManager.defaultManager()
    guard let url = try? fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false) else {
        // if the Document directory doesn't exist, things have gone off the deep end
        fatalError("No Document directory found!")
    }
    
    let fileURL = url.URLByAppendingPathComponent(filename)
    
    return fileURL
}

