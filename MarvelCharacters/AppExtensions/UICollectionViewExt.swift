//
//  UICollectionView.swift
//  InstagramClone
//
//  Created by Lova Krishna on 30/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        UIView.animate(withDuration: 1.5, animations: {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            view.backgroundColor = UIColor.init(red: 240, green: 240, blue: 240)
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            view.addSubview(messageLabel)
            messageLabel.centerX(inView: view)
            messageLabel.centerY(inView: view)
            messageLabel.text = message
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: Constants.trebuchetMS, size: 15)
            messageLabel.sizeToFit()
            self.backgroundView = view;
        }, completion: nil)
    }
    
    func restore() {
        UIView.animate(withDuration: 1.5, animations: {
            self.backgroundView = nil
        }, completion: nil)
        
    }
}
