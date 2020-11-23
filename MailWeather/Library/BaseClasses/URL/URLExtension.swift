//
//  File.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 23.11.2020.
//

import Foundation

extension URL {
    
    init? (iconId: String?) {
        guard let iconId = iconId else { return nil }
        
        var stringURL = Constants.Api.urlIcon + "/" + Constants.Api.pathIcon
        stringURL += iconId
        stringURL += Constants.Api.formatIcon
        
        guard let url = URL(string: stringURL) else { return nil }
        
        self = url
    }
}
