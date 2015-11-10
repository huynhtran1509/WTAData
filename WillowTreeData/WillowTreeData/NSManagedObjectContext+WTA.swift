//
//  NSManagedObjectContext+WTA.swift
//  WillowTreeCoreDataExample
//
//  Created by Robert Thompson on 9/15/15.
//  Copyright © 2015 Robert S. Thompson. All rights reserved.
//

import Foundation
import CoreData

public protocol NSManagedObjectContextSwiftImprovements
{
    func performBlockAndWait(block: (NSManagedObjectContext) throws -> Void) throws
    func performBlock(block: (NSManagedObjectContext) -> Void)
}

public extension NSManagedObjectContextSwiftImprovements where Self: NSManagedObjectContext
{
    func performBlockAndWait(block: (NSManagedObjectContext) throws -> Void) throws
    {
        var error: ErrorType? = nil
        
        let wrappedBlock: () -> Void = {
            [weak self]
            () -> Void in
            
            guard let context = self else { return } // theoretically impossible
            
            do {
                try block(context)
            }
            catch let blockError {
                error = blockError
            }
        }
        
        self.performBlockAndWait(wrappedBlock)
        
        if error != nil
        {
            throw error!
        }
    }
    
    func performBlock(block: (NSManagedObjectContext) -> Void)
    {
        let wrappedBlock = {
            [weak self]
            () -> Void in
            
            guard let context = self else { return }
            
            block(context)
        }
        
        self.performBlock(wrappedBlock)
    }
}

#if INCLUDE_DEFAULT_EXTENSIONS
extension NSManagedObjectContext: NSManagedObjectContextSwiftImprovements {}
#endif //INCLUDE_DEFAULT_EXTENSIONS