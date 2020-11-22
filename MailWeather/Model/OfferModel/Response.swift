//
//  Response.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct Response: Codable {
    let cod: String
    let message: Int
    let list: [List]
    let city: City
}
