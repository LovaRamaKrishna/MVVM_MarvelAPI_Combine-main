//
//  UIImageViewExt.swift
//  MarvelCharacters
//
//  Created by Apple on 08/07/22.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)

extension UIImageView {
    
  func loadRemoteImageFromServer(urlString: String) {
    let url = URL(string: urlString)
    image = nil
    activityView.center = self.center
    self.addSubview(activityView)
    activityView.startAnimating()
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = imageFromCache
        activityView.stopAnimating()
        activityView.removeFromSuperview()
        return
    }
    guard let urlValue = url else {
        print("URL WAS NOT CORRECT------------------")
        return
    }
    URLSession.shared.dataTask(with: urlValue) {
        data, response, error in
        DispatchQueue.main.async {
            activityView.stopAnimating()
            activityView.removeFromSuperview()
        }
          if let response = data {
              DispatchQueue.main.async {
                if let imageToCache = UIImage(data: response) {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }else{
                    self.loadRemoteImageFromServer(urlString: AppURLS.defaultImage)
                }
              }
          }
     }.resume()
  }
}

