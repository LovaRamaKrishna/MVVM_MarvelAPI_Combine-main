//
//  AppUtility.swift
//  MarvelCharacters
//
//  Created by Apple on 14/07/22.
//

import Foundation

class AppUtility {

    class func getInfoPlistPath () -> [String: Any]? {
      var config: [String: Any]?
        if let infoPlistPath = Bundle.main.url(forResource: "AppKeys", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    config = dict
                }
            } catch {
                print(error)
            }
        }
        return config
    }
    
}
