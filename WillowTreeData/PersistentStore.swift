//
//  PersistentStore.swift
//  WTADataExample
//
//  Created by Robert Thompson on 11/11/15.
//  Copyright © 2015 WillowTree, Inc. All rights reserved.
//

import Foundation

/**
 This struct is used to initialize a DataController object.
*/
public struct PersistentStore : CustomStringConvertible {
    public let storeType: String
    public let URL: NSURL
    public let configuration: String?
    public let options: [NSObject : AnyObject]?
    public let autoMigrating: Bool
    
    /**
     Initializer for PersistentStore struct
     
     - parameter storeType:     This is the type of NSPersistentStore you want to create. Examples include NSSQLiteStoreType (the default), NSInMemoryStore, and others.
     - parameter URL:           The URL for the peristent store. Required, but might be unused depending on the store type (an in-memory store doesn't actually save anything to disk).
     - parameter configuration: The configuration corresponding to this store. Usually nil, but has it's uses. See the model editor.
     - parameter options:       Standard NSPersistentStore options dictionary, this also varies based on type of store.
     - parameter autoMigrating: Send true to have this store handle migration automatically. Defaults to false.
     
     - returns: A PersistentStore structure suitable for use in initializing a DataController
     */
    public init(
        storeType: String = NSSQLiteStoreType,
        URL: NSURL = PersistentStore.getDocumentURLForFilename("Data.sqlite"),
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
            return "{\nstoreType: \(storeType)\nURL: \(URL)\nconfiguration: \(configuration ?? "None")\noptions: \(options?.description ?? "None")\n}"
        }
    }
    
    private static func getDocumentURLForFilename(filename: String) -> NSURL
    {
        let fileManager = NSFileManager.defaultManager()
        guard let url = try? fileManager.URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false) else {
            // if the Document directory doesn't exist, things have gone off the deep end
            fatalError("No Document directory found!")
        }
        
        let fileURL = url.URLByAppendingPathComponent(filename)
        
        return fileURL
    }
}

/**
 This is a wrapper class so Objective-C can make PersistentStore structs
*/
public final class WTADataPersistentStore: NSObject {
    internal let persistentStore: PersistentStore
    
    /**
     Default initializer
     
     - returns: Initialized instance with all default values (see PersistentStore struct)
     */
    public override required init() {
        persistentStore = PersistentStore()
    }
    
    /**
     Initializer that lets you specify various options for the PeristentStore. In keeping with typical
     Objective-C practice, passing nil for any parameter will get you the default.
     
     - parameter storeType:     This is the type of NSPersistentStore you want to create. Examples include NSSQLiteStoreType (the default), NSInMemoryStore, and others. The default is NSSQLiteStoreType.
     - parameter URL:           The URL for the peristent store. Required, but might be unused depending on the store type (an in-memory store doesn't actually save anything to disk). The default is a file in the Documents directory named "Data.sqlite"
     - parameter configuration: The configuration corresponding to this store. Usually nil, but has it's uses. See the model editor.
     - parameter options:       Standard NSPersistentStore options dictionary, this also varies based on type of store.
     - parameter autoMigrating: Send true to have this store handle migration automatically. Defaults to false.
     
     - returns: A WTADataPersistentStore instance suitable for use in initializing a DataController from Objective-C.
     */
    @objc public init(
        storeType: String?,
        URL: NSURL?,
        configuration: String?,
        options: [NSObject : AnyObject]?,
        autoMigrating: Bool
        ) {
            persistentStore = PersistentStore(
                storeType: storeType ?? NSSQLiteStoreType,
                URL: URL ?? PersistentStore.getDocumentURLForFilename("Data.sqlite"),
                configuration: configuration,
                options: options,
                autoMigrating: autoMigrating
            )
    }
}