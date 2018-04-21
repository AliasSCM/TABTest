//
//  CharacterWorker.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright (c) 2018 neemo. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class CharacterWorker
{
    var characterStore: CharacterStoreProtocol
    
    init(store : CharacterStoreProtocol)
    {
        self.characterStore  = store
    }
    
    func getCharactersFromEndPoint(completionHandler : @escaping (CharacterModels.ListCharacters.Response? , APIError?) -> Void)
    {
        self.characterStore.fetchCharacters(){result in
            switch result
            {
            case .Success(let response) :
                DispatchQueue.main.async
                {
                   completionHandler(response , nil)
                }
                break
            case .Failure(let error):
                DispatchQueue.main.async
                {
                    completionHandler(nil , error as? APIError)
                }
                break
            }
        }
        
    }
  
}