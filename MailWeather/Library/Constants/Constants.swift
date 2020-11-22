//
//  File.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct Constants {
    struct Api {
        static let url = "https://api.openweathermap.org"
        static let key = "da9f74ec5dd6df3021ce4c5f8ecdc569"
        static let path = "data/2.5/forecast"
        static let language = "ru"
    }
    
    struct Identifier {
        static let cell = "cell"
        static let homeVC = "HomeViewController"
        static let detailVC = "DetailTableViewController"
    }
    
    struct Other {
        static let countRows = 8
    }
}
