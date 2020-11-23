//
//  ErrorHandler.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 23.11.2020.
//

import Foundation
import Alamofire

class ErrorHandler {
    static func errorHandler(error: Error) {
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("Invalid URL: \(url) - \(error.localizedDescription)")
                
            case .parameterEncodingFailed(let reason):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("Parameter encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
            case .multipartEncodingFailed(let reason):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("Multipart encoding failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
            case .responseValidationFailed(let reason):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("Response validation failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
            case .responseSerializationFailed(let reason):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("Response serialization failed: \(error.localizedDescription)")
                print("Failure Reason: \(reason)")
                
            case .createURLRequestFailed(error: _):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("createURLRequestFailed")
                
            case .parameterEncoderFailed(reason: _):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("parameterEncoderFailed")
                
            case .sessionTaskFailed(error: _):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("NETWORK ERROR")
                
            case .urlRequestValidationFailed(reason: _):
                print("!!!!!!!!!!!!!!!!!!!!")
                print("urlRequestValidationFailed")
                
            default:
                print("!!!!!!!!!!!!!!!!!!!!")
                print("Other Error")
            }
            
            print("!!!!!!!!!!!!!!!!!!!!")
            print("Underlying error: \(String(describing: error.underlyingError))")
        } else if let error = error as? URLError {
            print("!!!!!!!!!!!!!!!!!!!!")
            print("URLError occurred: \(error)")
        } else {
            print("!!!!!!!!!!!!!!!!!!!!")
            print("Unknown error: \(error)")
        }
    }
}
