//
//  UIViewControllerExtensions.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 24/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showAlert(title: String?, message: String?, ok: String?, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ok, style: .default, handler: { _ in
            completion?()
        }))
        
        self.present(alert, animated: true) {
            guard completion == nil else { return }
            alert.view.superview?.isUserInteractionEnabled = true
            
        }
    }
}
