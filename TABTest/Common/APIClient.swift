//
//  BaseObject.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

// API Results Class.
/// Class that enxapsulates the result of an API call.
enum Result<T, U> where U: Error
{
    case success(T)
    case failure(U)
}

/// Enum enxapsulating if the API response expected is a JSON object or a JSONArray.
enum CollectionType : String
{
    case jsonObject = "jsonObject"
    case jsonArray      = "aray"
}

/// API Client protocol that uses NSURLSession to make API calls.
 /// - important: Classes using API client must implement APIClient protocol.
protocol APIClient
{
    /// NSURLSession obejct that is used to make API calls
    /// - important: This can only be got not written onto.
    var session: URLSession { get }
    /// Fetch function that is used to make an API call and get a response/data.
    /// - important: This dependency has to be fullfilled.
    /// - parameter request: NSURLRequest with details about the request.
    /// - parameter decode : The decodable object that is acuired after parsing to JSON. This class must confrom to protocol decodable
    /// - completion : Completion Handler returning APIResult in the function
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    ///  Select root function that is used to select the root from the JSON response. Everythig under this root will be used to parse the data. This is being used to parse only the data we need from the JSON and to discard the data we dont need
    /// - parameter dictionart: The JsonData
    /// returns : Selected JSON data under the root
    func selectRoot(dictionary : [String : Any]) -> Data?
    
}
/// API Client class.
/// - important: Classes using API client must implement APIClient protocol.
extension APIClient
{
    /// Completion Handler returning data after decoding is completed
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    // MARK: API Client Protocol Implementation
    
    /// Fetch function that is used to make an API call and get a response/data.
    /// - important: This dependency has to be fullfilled.
    /// - parameter request: NSURLRequest with details about the request.
    /// - parameter decode : The decodable object that is acuired after parsing to JSON. This class must confrom to protocol decodable
    /// - completion : Completion Handler returning APIResult in the function
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
           
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
    
    // MARK: Decoding Functions
    
    /// Function that performs the task of converting JSON to an instance of the class 'T' where T conforms to Decodable protocol
    /// - important: T has to confrom to decodeable protocol or else this will fail.
    /// - parameter request: NSURLRequest with details about the request.
    /// - parameter decodingType : The class type of the object that the function has to decode the JSON into
    /// - parameter completion : Completion Handler returning data after decoding is completed
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
                        print(dict)
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
    /// Case when API request fails
    case requestFailed
    /// Case when converting response to JSON fails
    case jsonConversionFailure
    /// Case when incoming response cannot be inferred or read. Typical case is when resppnse expects JSON but gets cleartex or html
    case invalidData
    /// Case when API response occurs but the result is not succesful
    case responseUnsuccessful
    /// Case when JSON to object decoding fails
    case jsonParsingFailure
    /// Computed property retusning error messages as string depending on error
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
/// important : Any cals using Endpoint must implement this protocol
protocol Endpoint
{
    var base: String { get }
    var path: String { get }
}

/// Extending Endpoint protocol to handle urlcomponents, parameters , request object etc
extension Endpoint
{
    /// Returns API Key for HTTP calls. In our case since API is public there is no key
    var apiKey: String
    {
        return ""
    }
    /// COmputed property returning UrLCOmponents with the correct path , optional params and api key.
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = apiKey
        return components
    }
    /// Computer property to return URLRquest Obejct
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}
