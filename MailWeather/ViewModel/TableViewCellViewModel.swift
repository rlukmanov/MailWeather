//
//  TableViewCellViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    
    // MARK: - Properties
    
    private var weatherAtTime: WeatherAtTime
    
    var dt: String {
        return convertTime(time: weatherAtTime.dt, timeZone: weatherAtTime.timezone)
    }
    
    var temperature: String {
        return convertCelsius(fromTemperature: weatherAtTime.temperature)
    }
    
    var weatherDescription: String {
        return weatherAtTime.weatherDescription.capitalizingFirstLetter()
    }
    
    var humidity: String {
        return "Влажность\n" + String(describing: weatherAtTime.humidity) + "%"
    }
    
    var precipitation: String {
        return "Осадки\n" + convertPrecipitation(value: weatherAtTime.precipitation) + "%"
    }
    
    // MARK: - Init
    
    init(weatherAtTime: WeatherAtTime) {
        self.weatherAtTime = weatherAtTime
    }
    
    // MARK: - Convert
    
    private func convertCelsius(fromTemperature temp: Double) -> String {
        return String(describing: Int(temp - 273.15)) + "°"
    }
    
    func convertTime(time: Int, timeZone: Int) -> String {
        guard let timeZone = TimeZone(secondsFromGMT: timeZone) else { return "" }
        
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        var calendar = Calendar.current
        var resultConvert: String = ""
        calendar.timeZone = timeZone
        
        let currentHour = calendar.component(.hour, from: date)
        resultConvert += String(describing: calendar.component(.hour, from: date))
        if currentHour < 10 {
            resultConvert.insert("0", at: resultConvert.startIndex)
        }
        resultConvert += ":00"
        
        return resultConvert
    }

    func convertPrecipitation(value: Double) -> String {
        return String(Int(round(value * 100)))
    }
}
