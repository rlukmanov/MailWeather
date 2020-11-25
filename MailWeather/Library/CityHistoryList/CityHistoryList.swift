//
//  CityHistoryList.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 25.11.2020.
//

import Foundation

class CityHistoryList {
    
    private var cityList: [String]
    private var identifier = "CityHistoryList"
    private var maxCount = 100
    
    // MARK: - Init
    
    init(cityList: [String]) {
        self.cityList = cityList
        saveAtUserDefaults()
    }
    
    init() {
        let defaults = UserDefaults.standard
        self.cityList = defaults.stringArray(forKey: identifier) ?? [String]()
    }
    
    // MARK: - getFilterList
    
    func getFilterList(searchText: String? = "") -> [String] {
        let returnCountElements = Constants.Other.cityHistoryListCount < cityList.count ? Constants.Other.cityHistoryListCount : cityList.count
        
        guard let searchText = searchText, !searchText.isEmpty else { return Array(cityList.prefix(returnCountElements))}
        
        let dataFiltered = cityList.filter { (dat) -> Bool in
            guard let substrIndex = dat.range(of: searchText, options: .caseInsensitive) else { return false }
            if substrIndex.contains(dat.startIndex) {
                return true
            } else {
                return false
            }
        }
        
        return Array(dataFiltered.prefix(returnCountElements))
    }
    
    func appendCity(appendCity city: String?) {
        guard let city = city else { return }
        
        if let positionRemove = cityList.firstIndex(of: city) {
            cityList.remove(at: positionRemove)
        }
        
        cityList.insert(city, at: cityList.startIndex)
        
        if cityList.count > maxCount {
            cityList.removeLast()
        }
        
        saveAtUserDefaults()
    }
    
    private func saveAtUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(cityList, forKey: identifier)
    }
}
