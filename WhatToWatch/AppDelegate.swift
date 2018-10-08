//
//  AppDelegate.swift
//  WhatToWatch
//
//  Created by Fran on 02/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let date = UserDefaults.standard.object(forKey: "updateTime") as? Date {
            if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 24 {
                PersistenceManager().cleanAllData()
                UserDefaults.standard.set(Date(), forKey:"updateTime")
                NotificationCenter.default.post(name: Notification.Name("ReloadAllData"), object: nil)
            }
        } else {
            UserDefaults.standard.set(Date(), forKey:"updateTime")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let date = UserDefaults.standard.object(forKey: "updateTime") as? Date {
            if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 24 {
                PersistenceManager().cleanAllData()
                UserDefaults.standard.set(Date(), forKey:"updateTime")
                NotificationCenter.default.post(name: Notification.Name("ReloadAllData"), object: nil)
            }
        } else {
            UserDefaults.standard.set(Date(), forKey:"updateTime")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.contextManager.saveContext()
    }
    
    lazy var datastoreCoordinator: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WhatToWhatchModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var contextManager: ContextManager = {
        return ContextManager()
    }()
}

