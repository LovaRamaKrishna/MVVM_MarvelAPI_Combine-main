//
//  Router.swift
//  MarvelCharacters
//
//  Created by Apple on 06/07/22.
//

import Foundation

enum Router {
    
    case getCharacters(searchKey: String, offSet: Int64)
    case getComics(offSet: Int64, filterKey: String)
    
    var publicKey: String {
        return AppUtility.getInfoPlistPath()?[Constants.publicKey] as? String ?? Constants.emptyString
    }
    
    var privateKey: String {
        return AppUtility.getInfoPlistPath()?[Constants.privateKey] as? String ?? Constants.emptyString
    }
    
    var scheme: String {
        switch self {
        case .getCharacters, .getComics:
            return Constants.httpskey
            
        }
    }
    
    var host: String {
        let base = Constants.urlHost
        switch self {
        case .getCharacters, .getComics:
            return base
        }
    }
    
    var path: String {
        switch self {
        case .getCharacters:
            return Constants.charactersPath
        case .getComics:
            return Constants.comicsPath
        }
    }
    
    var headers:[String : String]{
            switch self{
                //Add more when required
              default:
                var values = [Constants.content_type: Constants.application_json]
                values [Constants.accept_Encoding] = Constants.gzip
              return values
            }
        }
    
    var parameters: [URLQueryItem] {
        let timeStamp = Int(Date().timeIntervalSince1970)
        switch self {
        case .getCharacters(let stringKey, let offSet):
            if stringKey == Constants.emptyString {
                return [
                    URLQueryItem(name: Constants.ts, value: "\(timeStamp)"),
                    URLQueryItem(name: Constants.apikey, value: publicKey),
                    URLQueryItem(name: Constants.hash, value: getHash(ts: timeStamp)),
                    URLQueryItem(name: Constants.limit, value: AppPageLimit.pageLimit),
                    URLQueryItem(name: Constants.offset, value: "\(offSet)")
                ]
            } else {
                return [
                    URLQueryItem(name: Constants.ts, value: "\(timeStamp)"),
                    URLQueryItem(name: Constants.apikey, value: publicKey),
                    URLQueryItem(name: Constants.hash, value: getHash(ts: timeStamp)),
                    URLQueryItem(name: Constants.nameStartsWith, value: stringKey),
                    URLQueryItem(name: Constants.limit, value: AppPageLimit.pageLimit),
                    URLQueryItem(name: Constants.offset, value: "\(offSet)")
                ]
            }
        case .getComics(let offSet, let filterKey):
            if filterKey == Constants.emptyString {
                return [
                    URLQueryItem(name: Constants.ts, value: "\(timeStamp)"),
                    URLQueryItem(name: Constants.apikey, value: publicKey),
                    URLQueryItem(name: Constants.hash, value: getHash(ts: timeStamp)),
                    URLQueryItem(name: Constants.limit, value: AppPageLimit.pageLimit),
                    URLQueryItem(name: Constants.offset, value: "\(offSet)")
                ]
            } else {
                return [
                    URLQueryItem(name: Constants.ts, value: "\(timeStamp)"),
                    URLQueryItem(name: Constants.apikey, value: publicKey),
                    URLQueryItem(name: Constants.hash, value: getHash(ts: timeStamp)),
                    URLQueryItem(name: Constants.limit, value: AppPageLimit.pageLimit),
                    URLQueryItem(name: Constants.offset, value: "\(offSet)"),
                    URLQueryItem(name: Constants.dateDescriptor, value: filterKey)
                ]
            }
        }
    }
    
    var method: String {
        switch self {
        case .getCharacters, .getComics:
            return Constants.get
        }
    }
    
    func getUrl() -> URL {
        var components = URLComponents()
        switch self {
        case .getCharacters, .getComics:
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = parameters
        }
        let url = components.url!
        print("URL: \(url)")
        return url
    }
    
    private func getHash(ts: Int) -> String {
        let hash = "\(ts)\(privateKey)\(publicKey)"
        return hash.MD5
    }
    
}



