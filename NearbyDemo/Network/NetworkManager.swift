//
//  NetworkManager.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation

//https://api.seatgeek.com/2/venues?per_page=10&page=1&client_id=Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5&lat=12.971599&lon=77.594566&range=12mi&q=

enum HTTPMethod: String{
    case post = "POST"
    case get = "GET"
}

enum API{
    
    case search(param: [String: String])
    
    var path: String{
        
        switch self{
        case .search(let param):
            return "https://api.seatgeek.com/2/venues"
        }
        
    }
    
    var httpMethod: HTTPMethod{
        switch self{
        case .search:
            return .get
        }
    }
    
    var httpBody: Data?{
        switch self{
        case .search(let param):
            return nil
        }
    }
    
    var queryParams: [String: String] {
        switch self{
        case .search(let param):
            return param
        }
    }
    
    var request: URLRequest?{
        
        guard let url = URL(string: self.appendQueryParams(to: path, params: queryParams)) else{
            return nil
        }
        
        var req: URLRequest? = nil
        
        switch self {
            case .search:
                req = URLRequest(url: url)
        }
        
        req?.httpBody = httpBody
        req?.httpMethod = httpMethod.rawValue
        
        return req
    }
    
    func appendQueryParams(to urlString: String, params: [String: String]) -> String {
        guard var urlComponents = URLComponents(string: urlString) else {
            return urlString
        }
        
        guard !params.isEmpty else {
            return urlString
        }
        
        let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        if urlComponents.queryItems != nil {
            urlComponents.queryItems?.append(contentsOf: queryItems)
        } else {
            urlComponents.queryItems = queryItems
        }
        
        if let updatedUrlString = urlComponents.url?.absoluteString {
            return updatedUrlString
        } else {
            return urlString
        }
    }
}

enum APIError: Error{
    case error(Error)
    case apiURLError(API)
    case jsonParsingError(Data)
    case noResponse
}

protocol NetworkRepoType{
    
    func getAPIResponse<T: Codable>(api: API, callback: @escaping ((Result<T, APIError>)->Void))
    
}


final class NetworkManager: NetworkRepoType{
    
    func getAPIResponse<T: Codable>(api: API, callback: @escaping ((Result<T, APIError>)->Void)){
        
        DispatchQueue.global().async {
            let urlSession = URLSession.shared
            
            guard let request = api.request else {
                DispatchQueue.main.async {
                    callback(.failure(.apiURLError(api)))
                }
                return
            }
            
            urlSession.dataTask(with: request){ (data, response, error) in
                if let data = data{
                    do{
                        let obj =  try JSONDecoder().decode(T.self, from: data)
                        callback(.success(obj))
                    } catch let error {
                        if let decodingError = error as? DecodingError {
                            switch decodingError {
                                case .dataCorrupted(let context):
                                    print("Data Corrupted: \(context)")
                                case .keyNotFound(let key, let context):
                                    print("Key '\(key)' not found: \(context)")
                                case .typeMismatch(let type, let context):
                                    print("Type '\(type)' mismatch: \(context)")
                                case .valueNotFound(let type, let context):
                                    print("Value of type '\(type)' not found: \(context)")
                                @unknown default:
                                    print("Unknown Decoding Error")
                                }
                        } else {
                            print("An error occurred: \(error)")
                        }
                        DispatchQueue.main.async {
                            callback(.failure(.jsonParsingError(data)))
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        if let error = error{
                            callback(.failure(.error(error)))
                        }else{
                            callback(.failure(.noResponse))
                        }
                    }
                }
                
            }.resume()
            
        }
    }
    
}

