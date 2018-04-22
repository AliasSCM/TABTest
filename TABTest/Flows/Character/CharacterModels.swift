//
//  CharacterModels.swift
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

// MARK: EndPoint Details

/// Character Feed
///Enum encapsulating api end point for chracter feed.
enum CharacterFeed{
    case getCharacters
}
///Extending Endpoint to get end point details for character feed.
extension CharacterFeed: Endpoint {
    ///Computed property to get relative path for Endpoint.
    var path: String{
        switch self {
        case .getCharacters:
            return "/tabtestmarvelcharacters"
            
        }
    }
    ///Computed property to get base path for Endpoint.
    var base: String {
        return "http://bit.ly"
    }
}
/// Models related to the chacracter. Encapsulates, request , response and ViewModels based on UserCases.
enum CharacterModels{
    /// Use Case : MA-001
    enum ListCharacters{
        /// Request Object to get characters from EndPoint.
        struct Request
        {}
        /// Response Object after parsing results.
        struct Response : Decodable
        {
            var offset : Int!
            var limit  : Int!
            var total  : Int!
            var count  : Int!
            var characters : [Character]!
            enum CodingKeys : String, CodingKey {
                case characters = "results"
                case offset
                case limit
                case total
                case count
            }
        }
        /// View Model for listing characters in a table view
        struct CharacterListVM
        {
            var cellViewModels : [CharacterCellVM] = []
        }
        /// View Model for showing character in each cell of the list
        struct CharacterCellVM
        {
            static var CellID : String = "CharacterTableViewCell"
            var nameString : String!
            var photoUrl   : String!
        }
        
    }
     /// Use Case : MA-002
    enum CharacterDetail
    {
        struct CharacterDetailVM
        {
            var headingModel : ListCharacters.CharacterCellVM!
            var descriptionVM : CharacterDescriptionCellVM!
        }
        struct CharacterDescriptionCellVM
        {
            static var CellID : String = "CharacterDescriptionTableViewCell"
            var descriptionString : String!

        }
        
    }
}
