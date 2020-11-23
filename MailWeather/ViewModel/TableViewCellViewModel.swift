//
//  TableViewCellViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation
import UIKit

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
    
    var iconImage: UIImage {
        return weatherAtTime.icon
    }
    
    private var loadImage: UIImage?
    
    // MARK: - Init
    
    init(weatherAtTime: WeatherAtTime) {
        self.weatherAtTime = weatherAtTime
    }
    
    // MARK: - Convert
    
    private func convertCelsius(fromTemperature temp: Double) -> String {
        return String(describing: Int(temp - 273.15)) + "°"
    }
    
    private func convertTime(time: Int, timeZone: Int) -> String {
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

    private func convertPrecipitation(value: Double) -> String {
        return String(Int(round(value * 100)))
    }
    
    private func convertImageURL(iconId: String?) -> URL? {
        guard let iconId = iconId else { return nil }
        
        var stringURL = Constants.Api.urlIcon + "/" + Constants.Api.pathIcon
        stringURL += iconId
        stringURL += Constants.Api.formatIcon
        return URL(string: stringURL)
    }
}
