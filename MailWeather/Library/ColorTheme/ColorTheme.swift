//
//  ColorTheme.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 25.11.2020.
//

import Foundation

enum ColorTheme {
    case light
    case dark
    
    var backgroundColor: String {
        switch self {
        case .light:
            return "27BAFA"
        case .dark:
            return "0A0A0A"
        }
    }
    
    var leftGroundViewColor: String {
        switch self {
        case .light:
            return "03A545"
        case .dark:
            return "666666"
        }
    }
    
    var rightGroundViewColor: String {
        switch self {
        case .light:
            return "05F357"
        case .dark:
            return "333333"
        }
    }
    
    var externalRingViewColor: String {
        switch self {
        case .light:
            return "D0EAF3"
        case .dark:
            return "191919"
        }
    }
    
    var internalRingViewColor: String {
        switch self {
        case .light:
            return "8DD8F1"
        case .dark:
            return "333333"
        }
    }
    
    var centerCircleViewColor: String {
        switch self {
        case .light:
            return "2E92B1"
        case .dark:
            return "666666"
        }
    }
}
