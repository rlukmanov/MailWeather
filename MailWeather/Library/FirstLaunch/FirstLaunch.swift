//
//  FirstLaunch.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 24.11.2020.
//

import Foundation

class FirstLaunch {
    
    static func isFirstLaunch() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            return true
        }
    }
}
