//
//  ContextManager.swift
//  WhatToWatch
//
//  Created by Fran on 03/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

/**
 The Context Manager that will manage the merging of child contexts with Master ManagedObjectContext
 */
class ContextManager {
    
    let datastore: NSPersistentContainer!
    
    init() {
        datastore = NSPersistentContainer(name: "WhatToWhatchModel")
        datastore.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    init(testSotreCoordinator: NSPersistentContainer) {
        datastore = testSotreCoordinator
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator
        
        return mainManagedObjectContext
    }()
    
    func saveContext() {
        if self.managedObjectContext.hasChanges {
            DispatchQueue.main.async(execute: {
                do {
                    try self.managedObjectContext.save()
                } catch let mocSaveError as NSError {
                    print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
                }
            })
        }
    }    
}
