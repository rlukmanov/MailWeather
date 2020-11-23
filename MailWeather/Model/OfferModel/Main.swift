//
//  Main.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct Main {
    let temp: Double // Temperature
    let humidity: Int // Humidity, %
}

extension Main: Codable {
    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}
