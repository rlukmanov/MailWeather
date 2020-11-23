//
//  NetworkManager.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation
import Alamofire

// протокол безопасного конструктора готового запроса
protocol URLRequestBuilder: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

// дефолтная реализация протокола
extension URLRequestBuilder {
    var baseURL: String {
        return Constants.Api.url
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        switch method {
        case .get:
            request = try URLEncoding.default.encode(request, with: parameters)
        default:
            break
        }
        
        return request
    }
}

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
                    "lang": Constants.Api.language]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .showWeather:
            return .get
        }
    }
}

enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}

class NetworkManager<T: URLRequestBuilder> {
    
    func load<U: Codable>(service: T, decodeType: U.Type, completion: @escaping (Result<U>) -> Void) {
        guard let urlRequest = service.urlRequest else { return }
        
        AF.request(urlRequest).responseDecodable(of: U.self) { (response) in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
