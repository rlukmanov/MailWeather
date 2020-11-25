//
//  ViewModel.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation
import UIKit
import Alamofire
import CoreData

class ViewModel {
    
    // MARK: - Properties
    
    var cityHistoryList = CityHistoryList()
    var previousCityFromBase: Box<String?> = Box(nil)
    var previousDownloadCity: String?
    
    var city: Box<String?> = Box(nil)
    var image: Box<UIImage?> = Box(UIImage())
    var temperatuture: Box<String?> = Box(nil)
    var errorDescription: Box<String?> = Box(nil)
    var isHiddenRefreshButton: Box<Bool> = Box(true)
    var colorTheme: Box<ColorTheme> = Box(.light)
    
    private var weather: Weather?
    private let net = NetworkManager<ForeCastProvider>()
    var context: NSManagedObjectContext?
    var weatherInit: WeatherInitialize!
    weak var delegate: StopStartDownloadAnimation?
    
    // MARK: - loadData
    
    func loadData(city: String?) {
        
        guard var city = city else { return }
        city = city.trim()
        guard city.count > 0 else { return }
        
        errorDescription.value = nil
        isHiddenRefreshButton.value = true
        delegate?.startDownloadAnimation()
        previousDownloadCity = city
        
        net.load(service: .showWeather(city: city), decodeType: Response.self, completion: { (result) in
            switch result {
            case .success(let response):
                self.convertLoadedData(from: response)
                self.delegate?.stopDownloadAnimation()
            case .failure(let error):
                
                if let error = error as? AFError {
                    switch error {
                    
                    case .sessionTaskFailed(error: _):
                        self.errorDescription.value = Errors(code: -1).getDescriptionError()
                        self.isHiddenRefreshButton.value = false
                    default:
                        break
                    }
                    
                    self.delegate?.stopDownloadAnimation()
                }
            }
        })
    }
    
    // MARK: - setColorTheme
    
    private func setColorTheme(time: Int?, timeZone: Int?) {
        guard let timeZoneInt = timeZone, let time = time else { return }
        guard let timeZone = TimeZone(secondsFromGMT: timeZoneInt) else { return }
        
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let currentHour = calendar.component(.hour, from: date)
        if currentHour >= 23 || currentHour <= 9 {
            self.colorTheme.value = .dark
        } else {
            self.colorTheme.value = .light
        }

        return
    }
    
    // MARK: - convertLoadedData
    
    private func convertLoadedData(from response: Response) {
        
        guard let listWeather = response.list else {
            errorDescription.value = Errors(code: response.cod.getCodValue()).getDescriptionError()
            return
        }
        
        let timezone = response.city?.timezone
        var resultWeatherList = [WeatherAtTime]()
        
        listWeather.forEach { item in
            let url = URL(iconId: item.weather.first?.icon)
            let newIconImageView = UIImageView()
            let imageDetailImage: Box<UIImage?> = Box(nil)
            
            newIconImageView.load(url: url) { imageDetailImage.value = newIconImageView.image }
            
            let weatherAtTime = WeatherAtTime(dt: item.dt,
                                              temperature: item.main.temp,
                                              weatherDescription: item.weather.first?.weatherDescription ?? "",
                                              humidity: item.main.humidity,
                                              precipitation: item.pop,
                                              icon: imageDetailImage,
                                              timezone: timezone!)
            
            resultWeatherList.append(weatherAtTime)
        }
        
        let city = response.city?.name
        
        setColorTheme(time: listWeather.first?.dt, timeZone: timezone)
        
        let url = URL(iconId: listWeather.first?.weather.first?.icon)
        let newIconImageView = UIImageView()
        newIconImageView.load(url: url) { self.image.value = newIconImageView.image }
        
        self.cityHistoryList.appendCity(appendCity: city)
        self.city.value = city
        self.temperatuture.value = String(describing: Int((listWeather.first?.main.temp)!))  + "°"
        self.weather = Weather(city: city ?? "", list: resultWeatherList)
    }
    
    // MARK: - saveDataToBase
    
    func saveDataToBase() {
        guard let context = context else { return }
        
        let fetchRequest: NSFetchRequest<WeatherInitialize> = WeatherInitialize.fetchRequest()
        
        if let objects = try? context.fetch(fetchRequest) {
            for objects in objects {
                context.delete(objects)
            }
        }
        
        guard let weatherAtTimeList = self.weather?.list else { return }
        
        var index = 0
        for weatherAtTime in weatherAtTimeList {
            let weatherInitObject = WeatherInitialize(context: context)
            
            weatherInitObject.dt = Int32(weatherAtTime.dt)
            weatherInitObject.humidity = Int32(weatherAtTime.humidity)
            weatherInitObject.precipitation = weatherAtTime.precipitation
            weatherInitObject.image = weatherAtTime.icon.value?.pngData()
            weatherInitObject.temperature = weatherAtTime.temperature
            weatherInitObject.weatherDescription = weatherAtTime.weatherDescription
            weatherInitObject.timezone = Int32(weatherAtTime.timezone)
            weatherInitObject.city = self.city.value
            weatherInitObject.position = Int32(index)
            
            index += 1
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - loadDataFromBase
    
    func loadDataFromBase() {
        guard let context = context else { return }
        
        if FirstLaunch.isFirstLaunch() {
            getDataFromFile()
        } else {
            let fetchRequest: NSFetchRequest<WeatherInitialize> = WeatherInitialize.fetchRequest()
            
            do {
                let weatherInitList = try context.fetch(fetchRequest)
                
                guard let weatherInitFirst = weatherInitList.first else { return }
                
                self.temperatuture.value = String(describing: Int(weatherInitFirst.temperature)) + "°"
                self.city.value = weatherInitFirst.city
                self.previousCityFromBase.value = weatherInitFirst.city
                setColorTheme(time: Int(weatherInitFirst.dt), timeZone: Int(weatherInitFirst.timezone))
                
                if let imageData = weatherInitFirst.image {
                    self.image.value = UIImage(data: imageData)
                }
                
                self.weather = Weather(city: weatherInitFirst.city!, list: [WeatherAtTime]())
                
                for weather in weatherInitList {
                    insertDataFromBase(selectedWeather: weather)
                }
                
                weather?.list.sort { $0.index ?? 0 < $1.index ?? 0 }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - insertDataFrom
    
    private func insertDataFromBase(selectedWeather weatherInit: WeatherInitialize) {
        var imageDataImage = UIImage()
        let imageData = weatherInit.image
        
        if imageData != nil { imageDataImage = UIImage(data: imageData!)! }
        
        let weatherAtTime = WeatherAtTime(dt: Int(weatherInit.dt),
                                               temperature: weatherInit.temperature,
                                               weatherDescription: weatherInit.weatherDescription ?? "",
                                               humidity: Int(weatherInit.humidity),
                                               precipitation: weatherInit.precipitation,
                                               icon: Box(imageDataImage),
                                               timezone: Int(weatherInit.timezone),
                                               index: Int(weatherInit.position))
        
        self.weather?.list.append(weatherAtTime)
    }
    
    // MARK: - getDataFromFile
    
    private func getDataFromFile() {
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist") else { return }
        guard let dataDictionary = NSDictionary(contentsOfFile: pathToFile) else { return }
        
        self.city.value = dataDictionary["City"] as? String
        self.temperatuture.value = dataDictionary["Temperature"] as? String

        guard let imageName = dataDictionary["ImageName"] as? String else { return }
        self.image.value = UIImage(named: imageName)
        
        guard let cityList = dataDictionary["CityList"] as? [String] else { return }
        self.cityHistoryList = CityHistoryList(cityList: cityList)
    }
    
    // MARK: - deinit
    
    deinit {
        saveDataToBase()
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
