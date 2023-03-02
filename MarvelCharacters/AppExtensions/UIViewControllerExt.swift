//
//  UIViewControllerExt.swift
//  InstagramClone
//
//  Created by Lova Krishna on 24/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit


extension UIViewController {
    // ToHideKeyboardOnTapOnView
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if options.count == 0 {
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                completion(0)
            })
            alertController.addAction(OKAction)
        } else {
            
            for (index, option) in options.enumerated() {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    completion(index)
                }))
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

