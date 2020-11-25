//
//  Errors.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 23.11.2020.
//

import Foundation

enum Errors: Int {
    case notFound = 404
    case invalidApiKey = 401
    case networkBad = -1
    case other
    
    init(code: Int) {
        self = Errors(rawValue: code) ?? .other
    }
    
    init(code: String) {
        self = Errors(rawValue: Int(code) ?? 0) ?? .other
    }
    
    func getDescriptionError() -> String {
        switch self {
        case .notFound:
            return Constants.Errors.cityNotFound
        case .invalidApiKey:
            return Constants.Errors.invalidApiKey
        case .networkBad:
            return Constants.Errors.networkBad
        case .other:
            return Constants.Errors.other
        }
    }
}
