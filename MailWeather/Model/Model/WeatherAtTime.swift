//
//  WeatherAtTime.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation
import UIKit

struct WeatherAtTime {
    var dt: Int
    var temperature: Double
    var weatherDescription: String
    var humidity: Int
    var precipitation: Double
    var icon: UIImage
    var timezone: Int
}
