//
//  Result.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}
