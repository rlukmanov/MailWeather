//
//  File.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation
import Alamofire

enum ForeCastProvider: URLRequestBuilder {
    case showWeather(city: String)
    
    var path: String {
        switch self {
        case .showWeather:
            return Constants.Api.path
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .showWeather(let city):
            return ["q": city,
                    "appid": Constants.Api.key,
                    "lang": Constants.Api.language,
                    "cnt": Constants.Other.countRows,
                    "units": Constants.Api.units]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .showWeather:
            return .get
        }
    }
}
