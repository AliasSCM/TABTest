//
//  CharacterStoreProtocol.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

/**
Completion Handler for all character store functions
*/
enum CharacterStoreCompletionHandler
{
    /**
     Completion callback when multiple characters are fetched
     - returns: Void
     - parameter totalLlamas: Array of characters
     */
    typealias FetchCharactersHandler = (CharacterStoreResult<CharacterModels.ListCharacters.Response>) -> Void
    /**
     Completion callback when single character is fetched
     - returns: Void
     - parameter totalLlamas: Single Character object
     */
    typealias FetchCharacterHandler =  (CharacterStoreResult<Character>) -> Void
}
/**
 Template for result of CharacterStore functions
 */
enum CharacterStoreResult<U>
{   /**
     Success function when operation succeeds
     */
    case Success(result: U)
    /**
     Failure function when operation fails. Error is passed stating why operation failed
     */
    case Failure(error: Error)
}

/**
 CharacterStoreProtocol
 Protocol that gives access to CRUD operations related to character. Gives enums for errors and handlers
 */
protocol CharacterStoreProtocol
    
{
    /**
     Method definition to fetch multiple characters
     - returns: Void
     - parameter : Completion handler function which is called when fetch is completed.
     */
    func fetchCharacters(completionHandler: @escaping CharacterStoreCompletionHandler.FetchCharactersHandler)
    
    /**
     Method definition to fetch single character
     - returns: Void
     - parameter : Completion handler function which is called when fetch is completed
     */
    func fetchCharacter(completionHandler: @escaping CharacterStoreCompletionHandler.FetchCharacterHandler)
}

enum CharacterStoreErrorMessage: String
{
    case CharacterNotFound   =     "Character Could Not Be Found"
  
    
    static func getErrorMsg(error : CharacterStoreError) -> String
    {
        switch error
        {
            case .CannotFetch(let message , _):
                return message
        }
    }
}
/**
 CharacterStoreError
 Multiple Cases of error decleration when something fails while operating on the CharacterStore
 */
enum CharacterStoreError: Equatable, Error
{
    case CannotFetch(String  , CharacterStoreErrorMessage)
    
}

func ==(lhs: CharacterStoreError, rhs: CharacterStoreError) -> Bool
{
    switch (lhs, rhs)
    {
        case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
        default: return false
    }
}
