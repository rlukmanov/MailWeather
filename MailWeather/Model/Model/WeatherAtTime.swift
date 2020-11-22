//
//  WeatherAtTime.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct WeatherAtTime {
    var dt: String //Int
    var temperature: String //Double
    var weatherDescription: String
    var humidity: String //Int
    
    init(dt: Int, temperature: Double, weatherDescription: String, humidity: Int) {
        self.dt = "0"
        self.temperature = "0"//self.getCelsius(fromTemperature: temperature)
        self.weatherDescription = weatherDescription
        self.humidity = "0" // humidity
    }
    
    private func getCelsius(fromTemperature temp: Double) -> String {
        return String(describing: Int(temp - 273.15)) + "°"
    }
}
