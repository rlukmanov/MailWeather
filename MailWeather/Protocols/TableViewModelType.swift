//
//  TableViewModelType.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

protocol TableViewViewModelType {
    var numberOfRows: Int { get }
    func cellViewModel(forIndexPath: IndexPath) -> TableViewCellViewModelType?
    // var weather: Weather { get }
}
