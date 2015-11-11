//
//  WillowTreeData.swift
//  WillowTreeCoreDataExample
//
//  Created by Robert Thompson on 9/17/15.
//  Copyright © 2015 Robert S. Thompson. All rights reserved.
//

import Foundation
import CoreData



/// The clearing-house for all things data-related.
public class DataController: NSObject
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
    
    /**
     Initializer used from Objective-C to
     
     - parameter persistentStores: An array of WTADataPersistentStore instances. These will be added to the persistent store coordinator in the order they're passed in. They are added on a background queue, so may not be available immediately.
     
     - returns: An initialized DataController.
     */
    @objc(initWithPersistentStores:)
    public convenience init(objCPersistentStores persistentStores: [WTADataPersistentStore]) {
        self.init(persistentStores: persistentStores.map { $0.persistentStore })
    }
    
    /**
     Objective-C init, used only from Obj-C by virtue of being both private (so Swift can't see it) and
     dynamic (so the obj-c runtime *does* see it).
     
     - returns: DataController instance initialized to the default values.
     */
    private dynamic override convenience init() {
        self.init(persistentStores: [PersistentStore()])
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

