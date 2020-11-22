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
        return "0"
    }
    
    var weatherDescription: String {
        return "0"
    }
    
    var humidity: String {
        return "0"
    }
    
    init(weatherAtTime: WeatherAtTime) {
        self.weatherAtTime = weatherAtTime
    }
}
