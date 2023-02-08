//
//  SpinnerCollectionViewCell.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

class SpinnerCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configViews()
    }
    
    private func configViews() {
        
        self.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        spinner.startAnimating()
        spinner.isHidden = false 
    }
    
    lazy var spinner: UIActivityIndicatorView = {
        
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
}
