//
//  File.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 23.11.2020.
//

import Foundation
import Alamofire

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
