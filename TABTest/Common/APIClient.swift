//
//  BaseObject.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

enum Result<T, U> where U: Error
{
    case success(T)
    case failure(U)
}
enum CollectionType : String
{
    case jsonObject = "jsonObject"
    case jsonArray      = "aray"
}
protocol APIClient
{
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    func selectRoot(dictionary : [String : Any]) -> Data?
    
}

extension APIClient
{
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask
    {
      
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
            
                        let dict = data.convertToDictionary()
                        let selectedData = self.selectRoot(dictionary: dict!)
                        print("Selected JSON" , selectedData?.convertToDictionary()!)
                        let genericModel = try JSONDecoder().decode(decodingType, from: selectedData!)
                        completion(genericModel, nil)
    
                    }
                    catch
                    {
                        print(error)
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
   
}
/// Class encapsulating error from API calls.
enum APIError: Error
{
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String
    {
        switch self
        {
            case .requestFailed: return "Request Failed"
            case .invalidData: return "Invalid Data"
            case .responseUnsuccessful: return "Response Unsuccessful"
            case .jsonParsingFailure: return "JSON Parsing Failure"
            case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}
/// Protocol to encapsulate details of an endpoint
protocol Endpoint
{
    var base: String { get }
    var path: String { get }
}
extension Endpoint
{
    var apiKey: String
    {
        return ""
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = apiKey
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}
