//
//  ViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

class ViewModel: TableViewViewModelType {
    
    let net = NetworkManager<ForeCastProvider>()
    
    var temperatuture: Box<String?> = Box(nil)
    
    var city: Box<String?> = Box(nil)
    
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
    
    // MARK: - fetchRequest
    
    func loadData() {
        // startDownloadAnimation()
        
        net.load(service: .showWeather(city: "Moscow"), decodeType: Response.self, completion: { (result) in
            switch result {
            case .success(let response):
                self.saveLoadedData(from: response)
                // print(weatherList?.list.first)
            case .failure(let error):
                print(error)
            }
            
            // self.stopDownloadAnimation()
        })
    }
    
    // MARK: - saveLoadedData
    
    private func saveLoadedData(from response: Response) {
        let city = response.city.name
        let listWeather = response.list
        var resultWeatherList = [WeatherAtTime]()
        
        let startIndex = listWeather.startIndex
        let maxIndex = Constants.Other.countRows < listWeather.count ? Constants.Other.countRows : listWeather.count
        
        listWeather[startIndex..<maxIndex].forEach { item in
            let weatherAtTime = WeatherAtTime(dt: item.dt,
                                              temperature: item.main.temp,
                                              weatherDescription: item.weather.description,
                                              humidity: item.main.humidity)
            resultWeatherList.append(weatherAtTime)
        }
        
        self.city.value = city
        self.temperatuture.value = resultWeatherList.first?.temperature
        self.weather.value = Weather(city: city,
                                    list: resultWeatherList)
    }
}
