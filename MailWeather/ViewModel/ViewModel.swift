//
//  ViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation
import UIKit

class ViewModel {
    
    // MARK: - Properties
    
    private let net = NetworkManager<ForeCastProvider>()
    var temperatuture: Box<String?> = Box(nil)
    var city: Box<String?> = Box(nil)
    var image: Box<UIImage?> = Box(UIImage())
    
    private var weather: Weather?
    
    // MARK: - fetchRequest
    
    func loadData(city: String) {
        net.load(service: .showWeather(city: city), decodeType: Response.self, completion: { (result) in
            switch result {
            case .success(let response):
                self.saveLoadedData(from: response)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - saveLoadedData
    
    private func saveLoadedData(from response: Response) {
        let city = response.city.name
        let timezone = response.city.timezone
        let listWeather = response.list
        var resultWeatherList = [WeatherAtTime]()
        
        let startIndex = listWeather.startIndex
        let maxIndex = Constants.Other.countRows < listWeather.count ? Constants.Other.countRows : listWeather.count
        
        listWeather[startIndex..<maxIndex].forEach { item in
            let weatherAtTime = WeatherAtTime(dt: item.dt,
                                              temperature: item.main.temp,
                                              weatherDescription: item.weather.first?.weatherDescription ?? "",
                                              humidity: item.main.humidity,
                                              precipitation: item.pop,
                                              icon: item.weather.first?.icon ?? "",
                                              timezone: timezone)
            
            resultWeatherList.append(weatherAtTime)
        }
        
        let url = convertImageURL(iconId: listWeather.first?.weather.first?.icon)
        let newIconImageView = UIImageView()
        newIconImageView.load(url: url) {
            self.image.value = newIconImageView.image
        }
        
        self.city.value = city
        self.temperatuture.value = convertCelsius(fromTemperature: resultWeatherList.first?.temperature ?? 0)
        self.weather = Weather(city: city, list: resultWeatherList)
    }
    
    private func convertCelsius(fromTemperature temp: Double) -> String {
        return String(describing: Int(temp - 273.15)) + "°"
    }
    
    private func convertImageURL(iconId: String?) -> URL? {
        guard let iconId = iconId else { return nil }
        
        var stringURL = Constants.Api.urlIcon + "/" + Constants.Api.pathIcon
        stringURL += iconId
        stringURL += Constants.Api.formatIcon
        return URL(string: stringURL)
    }
}

// MARK: - TableViewViewModelType

extension ViewModel: TableViewViewModelType {
    
    func numberOfRows() -> Int {
        return weather?.list.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModel? {
        let weatherAtCell = (weather?.list[indexPath.row])!

        return TableViewCellViewModel(weatherAtTime: weatherAtCell)
    }
}
