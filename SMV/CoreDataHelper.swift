//
//  CoreDataHelper.swift
//  SMV
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation
import CoreData

/// Helper class for CoreData management.
class CoreDataHelper {
    
    private let container: NSPersistentContainer
    
    /// Returns the viewContext property of the associated persistent container.
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    /// Initialise an instance, also loading the CoreData persistent stores.
    init() {
        container = NSPersistentContainer(name: "SMVStore")
        // this should be sync call
        container.loadPersistentStores { (_, error) in
            if error != nil {
                print(error!)
                exit(-1)
            }
        }
    }
    
    /// Async save the container's viewContext, die on error.
    func save() {
        let context = viewContext
        context.perform {
            try! context.save()
        }
    }
    
    /// Sync perform the given block on the viewContext's queue.
    func performSync(block: @escaping ()-> Void) {
        viewContext.performAndWait(block)
    }
    
    /// Creates and inserts a new SMVItem object, returns it.
    func newItem()-> SMVItem {
        return SMVItem(context: viewContext)
    }

}

let sCDHelper = CoreDataHelper()
