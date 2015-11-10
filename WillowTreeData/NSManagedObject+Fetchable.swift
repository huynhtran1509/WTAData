//
//  NSManagedObject+Fetchable.swift
//  WillowTreeCoreDataExample
//
//  Created by Robert S. Thompson on 9/3/15.
//  Copyright © 2015 Robert S. Thompson. All rights reserved.
//

import Foundation
import CoreData

#if os(iOS)
    import UIKit
#endif

public extension NSManagedObject {
    public static var entityName: String? {
        return NSStringFromClass(self).componentsSeparatedByString(".").last
    }
    
    dynamic public func myFunc() { }
}

public enum FetchableError: ErrorType
{
    case NoEntityName
    case EntityHasNoCustomClassSpecified
    case InvalidRequestType
}

public protocol Fetchable
{
}

public extension Fetchable where Self: NSManagedObject
{
    public static func fetch(request: NSFetchRequest, inContext context: NSManagedObjectContext) throws -> [Self]
    {
        guard request.resultType == .ManagedObjectResultType else {
            throw FetchableError.InvalidRequestType
        }
        
        var error: ErrorType? = nil
        var result: [AnyObject] = []
        context.performBlockAndWait {
            do {
                result = try context.executeFetchRequest(request)
            }
            catch let blockError
            {
                error = blockError
            }
        }
        
        guard error != nil else
        {
            throw error!
        }
        
        guard let objects = result as? [Self] else
        {
            throw FetchableError.EntityHasNoCustomClassSpecified
        }
        
        return objects
    }
    
    public static func fetch(inContext context: NSManagedObjectContext, predicate: NSPredicate = NSPredicate(value: true), sortDescriptors: [NSSortDescriptor] = []) throws -> [Self]
    {
        let request = try self.requestWithPredicate(predicate, sortDescriptors: sortDescriptors)
        
        return try self.fetch(request, inContext: context)
    }
    
    public static func fetchFirst(inContext context: NSManagedObjectContext, predicate: NSPredicate = NSPredicate(value: true), sortDescriptors: [NSSortDescriptor] = []) throws -> Self?
    {
        let request = try self.requestWithPredicate(predicate, sortDescriptors: sortDescriptors)
        request.fetchLimit = 1
        
        return try self.fetch(request, inContext: context).first
    }
    
    private static func requestWithPredicate(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) throws -> NSFetchRequest
    {
        guard let entityName = NSStringFromClass(self).componentsSeparatedByString(".").last else {
            throw FetchableError.NoEntityName
        }
        
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = (sortDescriptors.isEmpty ? nil : sortDescriptors)
        
        return request
    }
    
    #if os(iOS)
    public static func fetchedResultsController(context: NSManagedObjectContext, predicate: NSPredicate = NSPredicate(value: true), sortDescriptors: [NSSortDescriptor], sectionNameKeyPath: String? = nil, cacheName: String? = nil, delegate: NSFetchedResultsControllerDelegate? = nil) throws -> NSFetchedResultsController
    {
        let request = try requestWithPredicate(predicate, sortDescriptors: sortDescriptors)
        
        let controller = NSFetchedResultsController(fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName)
       
        controller.delegate = delegate
        
        try controller.performFetch()
        
        return controller
    }
    #endif
}

#if INCLUDE_DEFAULT_EXTENSIONS
extension NSManagedObject: Fetchable {}
#endif //INCLUDE_DEFAULT_EXTENSIONS
