//
//  StringExtension.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import Foundation

/// Extension file which has all the extensions to classes we need.

/// Extending Data to handle converting to ARRAY and DICTIONARY
extension Data
{
    /// Function to convert Data to JSON Array
    /// returns : the converted JSON Array
    func convertToJSONArray() -> Array<[String : Any]>?
    {
        do
        {
            return (try JSONSerialization.jsonObject(with: self, options: []) as? Array<[String: Any]>)!
        }
        catch
        {
            print(error.localizedDescription)
        }
        return nil
    }
    /// Function to convert Data to JSON Object
    /// returns : the converted JSON Object
    func convertToDictionary() -> [String: Any]?
    {
        do
        {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        }
        catch
        {
            print(error.localizedDescription)
        }
        return nil
    }
    
}


