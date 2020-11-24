//
//  File.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct Constants {
    
    static let NameProject = "MailWeather"
    static let EntityName = "WeatherInitialize"
    
    struct Api {
        static let url = "https://api.openweathermap.org"
        static let urlIcon = "https://openweathermap.org"
        static let key = "da9f74ec5dd6df3021ce4c5f8ecdc569"
        static let path = "data/2.5/forecast"
        static let units = "metric"
        static let pathIcon = "img/wn/" // 10d@2x.png
        static let language = "usa"
        static let formatIcon = "@2x.png"
    }
    
    struct Identifier {
        static let cell = "cell"
        static let homeVC = "HomeViewController"
        static let detailVC = "DetailTableViewController"
    }
    
    struct Errors {
        static let cityNotFound = "Unfortunately the city was not found. Check and try again"
        static let networkBad = "Internet doesn't work. Check your connection and try again"
        static let invalidApiKey = "Oops, invalid api key. The developer will fix it soon"
        static let other = "Oh, some mistake. We'll fix it soon"
    }
    
    struct Other {
        static let countRows = 8
        static let resultListCount: Int = 7
    }
}
