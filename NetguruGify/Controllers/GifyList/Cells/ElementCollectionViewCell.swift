//
//  ElementCollectionViewCell.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

class ElementCollectionViewCell<Element>: UICollectionViewCell {
    
    open func config(with: Element, _ offset: Int) {
        fatalError("implement config with element!")
    }
}
