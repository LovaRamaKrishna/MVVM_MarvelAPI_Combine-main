//
//  UIWindowExt.swift
//  MarvelCharacters
//
//  Created by Apple on 08/07/22.
//

import Foundation
import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            if #available(iOS 15, *){
                return UIApplication
                    .shared
                    .connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }

            } else {
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
