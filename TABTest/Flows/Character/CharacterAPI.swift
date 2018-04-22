//
//  CharacterAPI.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

/**
 CharacterAPI class that handles all API calls related to character entity. Implements APIClient and CharacterStoreProtocol
 */
class CharacterAPI: APIClient , CharacterStoreProtocol{
    ///NSURL session object that is used for API calls
    let session: URLSession
    
    // MARK: Init Methods
    /**
     Init Method with configuration
     - parameter configuration: URLSessionConfiguration that session object needs
     */
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    /**
     Convinience Init Method with default configuration
     */
    convenience init() {
        self.init(configuration: .default)
    }
    
    // MARK: CharacterStore Protocol Implementation
    
    // Implementing CharacterStoreProtocol.
    /// Method to fetch characters from API
    /// - parameter completionHandler : Called when fetch is complete
    func fetchCharacters(completionHandler: @escaping CharacterStoreCompletionHandler.FetchCharactersHandler)
    {
        self.getFeed(from: CharacterFeed.getCharacters)
        { result in
            switch result
            {
            case .success(let characterFeedResult):
                guard let results = characterFeedResult else { return }
                completionHandler(CharacterStoreResult.Success(result: results))
            case .failure(let error):
                completionHandler(CharacterStoreResult.Failure(error: error))
                print("the error \(error)")
            }
        }
    }
    
    // Implementing CharacterStoreProtocol.
    /// Method to fetch characters from API
    /// - parameter completionHandler : Called when fetch is complete
    func fetchCharacter(completionHandler: @escaping CharacterStoreCompletionHandler.FetchCharacterHandler)
    {}
    
    // MARK: Private Worker methods that uses APIClient to get CharacterData
    
    // Private function that does the work of getting the characters feed using APIClient instance.
    /// - parameter feedType : Called when fetch is complete
    /// - parameter completion : Completion Handler that is called when getting feed completes
    fileprivate func getFeed(from feedType: CharacterFeed, completion: @escaping (Result<CharacterModels.ListCharacters.Response?, APIError>) -> Void)
    {
        fetch(with: feedType.request , decode: { json -> CharacterModels.ListCharacters.Response? in
            guard let result = json as? CharacterModels.ListCharacters.Response else { return  nil }
            return result
        }, completion: completion)
    }
    // Implementing APIClient.
    /// Implementing API Clients selectRoot method. This methid selects the root of the JSON to parse from.
    /// - important: This is being done so we parse only the required character data for this use case.
    /// - parameter dictionary: dictionary the JSON to be passed where root is selected from.
    /// - returns: JSON coded into Data
    func selectRoot(dictionary: [String : Any]) -> Data?
    {
        if let data :  [String : Any] = dictionary["data"] as? [String : Any]
        {
            do
            {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                return jsonData
            }
            catch
            {
                return nil
            }
        }
        return nil
    }
}


