//
//  StringExtension.swift
//  TABTest
//
//  Created by master on 4/21/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import Foundation

extension Data
{
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


