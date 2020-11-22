//
//  City.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let country: String
    let timezone: Int // Shift in seconds from UTC
}
