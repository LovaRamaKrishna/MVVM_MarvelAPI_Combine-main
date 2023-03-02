//
//  Extensions.swift
//  MarvelCharacters
//
//  Created by Apple on 06/07/22.
//

import Foundation
import CryptoKit

extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
    return computed.map { String(format: Constants.hasValue, $0) }.joined()
    }
}
    
