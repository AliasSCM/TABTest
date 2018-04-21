//
//  Charcter.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

struct Thumbnail : Decodable{
    let path : String!
    let ext  : String!
    var fullPath : String{
        get{ return path + ext }
    }
    enum CodingKeys : String, CodingKey {
        case path
        case ext = "extension"
    }
    
   
}

struct URLContainer : Decodable{
    var type : String
    var url  : String
    
    enum CodingKeys : String, CodingKey {
        case type
        case url
    }
}

struct CharacterPagedData
{
    
}
struct Character: Decodable{
    var  id             : Int
    var  name           : String
    var  descrip        : String
    var  thumbnail      : Thumbnail
    var  urls           : [URLContainer]
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case descrip = "description"
        case thumbnail
        case urls 
    }

}
