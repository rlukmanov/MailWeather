//
//  List.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct List {
    let dt: Int // Time of data forecasted, unix, UTC
    let main: Main
    let weather: [WeatherModel]
    let pop: Double // Probability of precipitation
    let sys: Sys
    let dtTxt: String // Time of data forecasted, ISO, UTC
}

extension List: Codable {
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, pop, sys
        case dtTxt = "dt_txt"
    }
}
