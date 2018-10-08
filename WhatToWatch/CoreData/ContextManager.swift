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
class ContextManager: NSObject {
    
    let datastore: NSPersistentContainer!
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.datastore = appDelegate.datastoreCoordinator
        super.init()
    }
    
    init(testSotreCoordinator: NSPersistentContainer) {
        datastore = testSotreCoordinator
        super.init()
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
