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
        return String(describing: Int(weatherAtTime.temperature)) + "°"
    }
    
    var weatherDescription: String {
        let description = weatherAtTime.weatherDescription.capitalizingFirstLetter()
        if description.components(separatedBy: " ").count > 1 {
            let newDescription = description.replacingOccurrences(of: " ", with: "\n", options: .literal, range: nil)
            return newDescription
        }
        
        return description
    }
    
    var humidity: String {
        return "Humidity\n" + String(describing: weatherAtTime.humidity) + "%"
    }
    
    var precipitation: String {
        return "Precipitation\n" + convertPrecipitation(value: weatherAtTime.precipitation) + "%"
    }
    
    var loadImage: Box<UIImage?> = Box(nil)
    
    // MARK: - Init
    
    init(weatherAtTime: WeatherAtTime) {
        self.weatherAtTime = weatherAtTime
        self.loadImage = weatherAtTime.icon
    }
    
    // MARK: - Convert
    
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
}
