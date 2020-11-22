//
//  TableViewCellViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    
    private var weatherAtTime: WeatherAtTime
    
    var dt: String {
        return String(describing: weatherAtTime.dt)
    }
    
    var temperature: String {
        return getCelsius(fromTemperature: weatherAtTime.temperature)
    }
    
    var weatherDescription: String {
        //print(String(describing: weatherAtTime.weatherDescription))
        return "Ясно" //
    }
    
    var humidity: String {
        print(weatherAtTime.humidity)
        return "0"
    }
    
    init(weatherAtTime: WeatherAtTime) {
        self.weatherAtTime = weatherAtTime
    }
    
    private func getCelsius(fromTemperature temp: Double) -> String {
        return String(describing: Int(temp - 273.15)) + "°"
    }
}
