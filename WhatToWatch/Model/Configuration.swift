//
//  Configuration.swift
//  WhatToWatch
//
//  Created by Francisco on 10/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import Foundation

class Configuration {
    func mustUpdateData() -> Bool {
        if let date = UserDefaults.standard.object(forKey: "updateTime") as? Date {
            if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff > 24 {
                return true
            }
        } else {
            UserDefaults.standard.set(Date(), forKey:"updateTime")
        }
        return false
    }
    
    func dataUpdated() {
        UserDefaults.standard.set(Date(), forKey:"updateTime")
        NotificationCenter.default.post(name: Notification.Name("ReloadAllData"), object: nil)
    }
}
