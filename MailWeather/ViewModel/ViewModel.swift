//
//  ViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

class ViewModel: TableViewViewModelType {

    var temperatuture: String {
        return "0"
    }
    
    var city: String {
        return "0" // weather.city
    }
    
    var weather: Box<Weather?> = Box(nil)
    
    var weatherModel = Weather(city: "Moscow",
                                  list: [ WeatherAtTime(dt: 0, temperature: 0, weatherDescription: "0", humidity: 0),
                                          WeatherAtTime(dt: 1, temperature: 0, weatherDescription: "0", humidity: 0),
                                          WeatherAtTime(dt: 2, temperature: 0, weatherDescription: "0", humidity: 0),
                                          WeatherAtTime(dt: 3, temperature: 0, weatherDescription: "0", humidity: 0),
                                          WeatherAtTime(dt: 4, temperature: 0, weatherDescription: "0", humidity: 0),
                                          WeatherAtTime(dt: 5, temperature: 0, weatherDescription: "0", humidity: 0),
                                          WeatherAtTime(dt: 6, temperature: 0, weatherDescription: "0", humidity: 0),
                                          WeatherAtTime(dt: 7, temperature: 0, weatherDescription: "0", humidity: 0)])
    
    func numberOfRows() -> Int {
        return weatherModel.list.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let weatherAtCell = weatherModel.list[indexPath.row]
        return TableViewCellViewModel(weatherAtTime: weatherAtCell)
    }
}
