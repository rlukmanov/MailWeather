//
//  Weather.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct WeatherModel {
    let id: Int
    let main: String // Group of weather parameters
    let weatherDescription: String // Weather condition within the group
    let icon: String // Weather icon id
}

extension WeatherModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
