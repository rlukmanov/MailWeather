//
//  Main.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct Main: Codable {
    let temp: Double // Temperature
    let humidity: Int // Humidity, %

    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}
