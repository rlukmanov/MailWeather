//
//  StringExtension.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func trim() -> String {
        let stringWithoutSpacesAtEnd = self.trimmingCharacters(in: .whitespaces)
        let substrSpaces = stringWithoutSpacesAtEnd.components(separatedBy: .whitespaces)
        return substrSpaces.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
