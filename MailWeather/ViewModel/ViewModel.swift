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
    
    var data: [String] = ["Moscow", "London", "New York", "Los Angeles", "Berlin"]
    var dataFiltered: [String] = []
    var previousCity: String = "Moscow"
    
    var temperatuture: Box<String?> = Box(nil)
    var city: Box<String?> = Box(nil)
    var image: Box<UIImage?> = Box(UIImage())
    var errorDescription: Box<String?> = Box(nil)
    var isHiddenRefreshButton: Box<Bool> = Box(true)
    
    private var weather: Weather?
    private let net = NetworkManager<ForeCastProvider>()
    var context: NSManagedObjectContext?
    weak var delegate: StopStartDownloadAnimation?
    
    // MARK: - loadData
    
    func loadData(city: String?) {
        
        guard var city = city else { return }
        city = city.trim()
        guard city.count > 0 else { return }
        
        errorDescription.value = nil
        isHiddenRefreshButton.value = true
        delegate?.startDownloadAnimation()
        previousCity = city
        
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
    
    // MARK: - getFilterList
    
    func getFilterList(searchText: String) -> [String] {
        dataFiltered = searchText.isEmpty ? data : data.filter({ (dat) -> Bool in
            dat.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        return Array(dataFiltered.prefix(min(dataFiltered.count, Constants.Other.resultListCount)))
    }
    
    // MARK: - convertLoadedData
    
    private func convertLoadedData(from response: Response) {
        
        guard let listWeather = response.list else {
            errorDescription.value = Errors(code: response.cod.getCodValue()).getDescriptionError()
            return
        }
        
        let city = response.city!.name
        let timezone = response.city?.timezone
        var resultWeatherList = [WeatherAtTime]()
        
        listWeather.forEach { item in
            let url = URL(iconId: item.weather.first?.icon)
            let newIconImageView = UIImageView()
            let imageDetailImage: Box<UIImage?> = Box(nil)
            
            newIconImageView.load(url: url) {
                imageDetailImage.value = newIconImageView.image
            }
            
            let weatherAtTime = WeatherAtTime(dt: item.dt,
                                              temperature: item.main.temp,
                                              weatherDescription: item.weather.first?.weatherDescription ?? "",
                                              humidity: item.main.humidity,
                                              precipitation: item.pop,
                                              icon: imageDetailImage,
                                              timezone: timezone!)
            
            resultWeatherList.append(weatherAtTime)
        }
        
        let url = URL(iconId: listWeather.first?.weather.first?.icon)
        let newIconImageView = UIImageView()
        newIconImageView.load(url: url) { self.image.value = newIconImageView.image }
        
        self.city.value = city
        self.temperatuture.value = String(describing: Int((listWeather.first?.main.temp)!))  + "°"
        self.weather = Weather(city: city, list: resultWeatherList)
        
        saveDataToBase()
    }
    
    // MARK: - saveDataToBase
    
    private func saveDataToBase() {
        guard let context = context else { return }
        
        let fetchRequest: NSFetchRequest<WeatherInitialize> = WeatherInitialize.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for objects in objects {
                context.delete(objects)
            }
        }
        
        let weatherInit = WeatherInitialize(context: context)
        
        weatherInit.city = self.city.value
        weatherInit.image =  self.image.value?.pngData()
        weatherInit.temperatuture = self.temperatuture.value
        
        let weatherList = [WeatherInitializeDetailList(context: context)] as NSMutableOrderedSet
        
        guard let weatherAtTimeList = self.weather?.list else { return }
        
        for weatherAtTime in weatherAtTimeList {
            let currentWeather = WeatherInitializeDetailList(context: context)
            
            currentWeather.dt = Int32(weatherAtTime.dt)
            currentWeather.humidity = Int32(weatherAtTime.humidity)
            currentWeather.precipitation = weatherAtTime.precipitation
            currentWeather.loadImage = weatherAtTime.icon.value?.pngData()
            currentWeather.temperature = weatherAtTime.temperature
            currentWeather.weatherDescription = weatherAtTime.weatherDescription
            
            weatherList.add(currentWeather)
        }
        
        weatherInit.listDetailWeather = weatherList
        
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
                let weatherInit = try context.fetch(fetchRequest)
                
                guard let weather = weatherInit.first else { return }
                insertDataFrom(selectedWeather: weather)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - insertDataFrom
    
    private func insertDataFrom(selectedWeather weatherInit: WeatherInitialize) {
        guard let imageData = weatherInit.image else { return }
        print("3")
        self.image.value = UIImage(data: imageData)
        self.temperatuture.value = weatherInit.temperatuture
        self.city.value = weatherInit.city
    }
    
    // MARK: - getDataFromFile
    
    private func getDataFromFile() {
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist") else { return }
        guard let dataDictionary = NSDictionary(contentsOfFile: pathToFile) else { return }
        
        guard let context = context else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.EntityName, in: context) else { return }
        guard let weatherInitialize = NSManagedObject(entity: entity, insertInto: context) as? WeatherInitialize else { return }

        weatherInitialize.city = dataDictionary["city"] as? String
        weatherInitialize.temperatuture = dataDictionary["temperatuture"] as? String

        guard let imageName = dataDictionary["imageName"] as? String else { return }
        let image = UIImage(named: imageName)
        guard let imageData = image?.pngData() else { return }
        weatherInitialize.image = imageData
        
        insertDataFrom(selectedWeather: weatherInitialize)
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
