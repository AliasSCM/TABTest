//
//  CharacterAPI.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

class CharacterAPI: APIClient , CharacterStoreProtocol
{
    
   
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
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
    
    func fetchCharacter(completionHandler: @escaping CharacterStoreCompletionHandler.FetchCharacterHandler)
    {
        
    }
    
    //in the signature of the function in the success case we define the Class type thats is the generic one in the API
    func getFeed(from feedType: CharacterFeed, completion: @escaping (Result<CharacterModels.ListCharacters.Response?, APIError>) -> Void)
    {
        fetch(with: feedType.request , decode: { json -> CharacterModels.ListCharacters.Response? in
            guard let result = json as? CharacterModels.ListCharacters.Response else { return  nil }
            return result
        }, completion: completion)
    }
    
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


