//
//  Cod.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 23.11.2020.
//

import Foundation

enum Cod: Codable {
    case int(Int)
    case string(String)

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value): try container.encode(value)
        case .string(let value): try container.encode(value)
        }
    }
    
    func getCodValue() -> String {
        switch self {
        case .int(let value):
            return String(describing: value)
        case .string(let value):
            return value
        }
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        do {
            self = .int(try value.decode(Int.self))
        } catch DecodingError.typeMismatch {
            self = .string(try value.decode(String.self))
        }
    }
}
