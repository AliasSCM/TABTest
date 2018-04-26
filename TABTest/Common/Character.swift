//
//  Charcter.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

/// Class encapsulating Character Thumbnail.
/// -important : All properties of this class myst be valid. This extends Decodable so this object can be parsed from JSON
struct Thumbnail : Decodable{
    /// The path URL as a string where the thumbnail image resides
    let path : String!
    /// The extension of the image URL, can be .jpg, .png etc
    let ext  : String!
    /// Computed property to return full path of the image
    var fullPath : String{
        get{ return path + "." + ext }
    }
    /// Implementing Decodable to match JSON keys to Thumbnails properties
    enum CodingKeys : String, CodingKey {
        case path
        case ext = "extension"
    }
}
/// Class encapsulating URLContainer class which contains URL and Type
struct URLContainer : Decodable{
    /// Type of what URL contains as string
    var type : String
    /// URL as a string
    var url  : String
     /// Implementing Decodable to match JSON keys to Thumbnails properties
    enum CodingKeys : String, CodingKey {
        case type
        case url
    }
}
/// Character class encaspulating all details of the Character
struct Character: Decodable{
    /// id of the character as an INT
    var  id             : Int
    /// name of the character
    var  name           : String
    /// description of the character
    var  descrip        : String
    /// thumbnails of the character as Thumbnail array
    var  thumbnail      : Thumbnail
    /// URL's of the character as URL array
    var  urls           : [URLContainer]
    /// Implementing Decodable to match JSON keys to Thumbnails properties
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case descrip = "description"
        case thumbnail
        case urls 
    }
    /// Function to get URLContainer depdnding on type
    /// - parameter type : Type of URL as string
    func getUrl(type : String) -> URLContainer!
    {
        for urlContainer in self.urls{
            if (urlContainer.type == type){
                return urlContainer
            }
        }
        return nil
    }
}
