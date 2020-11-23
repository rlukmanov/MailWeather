//
//  Response.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct Response: Codable {
    let cod: Cod
    let list: [List]?
    let city: City?
}
