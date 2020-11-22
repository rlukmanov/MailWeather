//
//  ViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

struct WeatherStruct {
    var temp: String
    var city: String
}

class ViewModel {
    
    private var weather = WeatherStruct(temp: "5", city: "Moscow")
    
    var temperatuture: String {
        return weather.temp + "°"
    }
    
    var city: String {
        return weather.city
    }
}
