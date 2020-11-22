//
//  ViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

class ViewModel {
    
    // MARK: - Properties
    
    let net = NetworkManager<ForeCastProvider>()
    weak var delegate: StartStopDownloadAnimation?
    var temperatuture: Box<String?> = Box(nil)
    var city: Box<String?> = Box(nil)
    var weather: Weather?
    
    // MARK: - fetchRequest
    
    func loadData() {
        delegate?.startDownloadAnimation()
        net.load(service: .showWeather(city: "Moscow"), decodeType: Response.self, completion: { (result) in
            switch result {
            case .success(let response):
                self.saveLoadedData(from: response)
            case .failure(let error):
                print(error)
            }
            self.delegate?.stopDownloadAnimation()
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
                                              timezone: timezone)
            
            resultWeatherList.append(weatherAtTime)
        }
        
        self.city.value = city
        self.temperatuture.value = getCelsius(fromTemperature: resultWeatherList.first?.temperature ?? 0)
        self.weather = Weather(city: city, list: resultWeatherList)
    }
    
    private func getCelsius(fromTemperature temp: Double) -> String {
        return String(describing: Int(temp - 273.15)) + "°"
    }
}

// MARK: - TableViewViewModelType

extension ViewModel: TableViewViewModelType {
    
    func numberOfRows() -> Int {
        return weather?.list.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        let weatherAtCell = (weather?.list[indexPath.row])!
        return TableViewCellViewModel(weatherAtTime: weatherAtCell)
    }
}
