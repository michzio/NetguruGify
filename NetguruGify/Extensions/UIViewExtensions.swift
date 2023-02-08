//
//  UIViewExtensions.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

extension UIView {
    
    @objc class var identifier : String {
        return String(describing: self)
    }
}
