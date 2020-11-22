//
//  TableViewCellModelType.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

protocol TableViewCellViewModelType: class {
    var dt: String { get }
    var temperature: String { get }
    var weatherDescription: String { get }
    var humidity: String { get }
    var precipitation: String { get }
}
