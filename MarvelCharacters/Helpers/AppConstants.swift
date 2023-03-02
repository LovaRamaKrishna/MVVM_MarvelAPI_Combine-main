//
//  AppConstants.swift
//  MarvelCharacters
//
//  Created by Apple on 14/07/22.
//

import Foundation

struct Constants {
    
    static let noInternet = "No Internet"
    static let httpstatusCode = "HTTP status code:"
    static let error = "Error:"
    static let privateKey = "privateKey"
    static let publicKey  = "publicKey"
    static let httpskey   = "https"
    static let urlHost    = "gateway.marvel.com"
    static let charactersPath = "/v1/public/characters"
    static let comicsPath     = "/v1/public/comics"
    static let content_type   = "Content-Type"
    static let application_json = "application/json"
    static let accept_Encoding = "Accept-Encoding"
    static let gzip            = "gzip"
    static let emptyString     = ""
    static let ts              = "ts"
    static let apikey          = "apikey"
    static let hash            = "hash"
    static let limit           = "limit"
    static let offset          = "offset"
    static let nameStartsWith  = "nameStartsWith"
    static let dateDescriptor  = "dateDescriptor"
    static let get             = "GET"
    static let windoError      = "No main window."
    static let hasValue        = "%02hhx"
    static let ashmark         = "#"
    static let invalid_Hex_code = "Invalid hex code used."
    static let trebuchetMS      = "TrebuchetMS"
    static let reuseIdentifier  = "Cell"
    static let ok               = "OK"
    static let searchHistoryArray = "SearchHistoryArray"
    static let searchPlaceHolder  = "Search your favorite character..."
    static let defaultCoderError  = "init(coder:) has not been implemented"
}

struct AppPageLimit {
    static let pageLimit       = "20"
}

struct TitlesConstants {
    static let charactersTitle = "Characters"
    static let comicsTitle = "Comics"
}

struct ImageNames {
    static let charactersTabBarUnselectedImage  = "person.2.crop.square.stack"
    static let charactersTabBarselectedImage  = "person.2.crop.square.stack.fill"
    static let comicsTabBarUnselectedImage  = "person.crop.rectangle.stack"
    static let comicsTabBarselectedImage  = "person.crop.rectangle.stack.fill"
}

struct AppURLS {
    static let defaultImage        =   "https://via.placeholder.com/300/000000/FFFFFF/?text=Image%20Not%20Found"
    static let extentionImageUrl   =   "/standard_medium."
}
