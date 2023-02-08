//
//  GifyCollectionViewCell.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

protocol GifyCellDelegate : class {
    
    func didSelectGify(_ cell: GifyCollectionViewCell, id: String)
    func didDeselectGify(_ cell: GifyCollectionViewCell, id: String)
}

extension GifyCellDelegate {
    func didSelectGify(_ cell: GifyCollectionViewCell, id: String) { }
    func didDeselectGify(_ cell: GifyCollectionViewCell, id: String) { }
}

//var cache = NSCache<NSString, UIImage>()

class GifyCollectionViewCell: ElementCollectionViewCell<Gify> {
    
    var id: String!
    
    weak var delegate: GifyCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configViews()
        configGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configViews()
        configGestures()
    }
    
    private func configViews() {
        
        self.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        self.addSubview(label)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        self.addSubview(button)
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
    }
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .green 
       
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var label: UILabel = {
       
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var button : UIButton = {
        
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "Star")?.colored(.lightGray), for: .normal)
        button.setImage(UIImage(named: "Star")?.colored(.yellow), for: .highlighted)
        button.setImage(UIImage(named: "Star")?.colored(.yellow), for: .selected)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        return button
        
    }()
    
    override func config(with gify: Gify, _ offset: Int) {
        
        //self.label.text = gify.title + " \(offset)"
        self.id = gify.id
        
        /*
        if let image = cache.object(forKey: NSString(string: gify.id)) as? UIImage {
            imageView.image = image
            return
        }*/
        
        if let imageUrl = gify.images.dictionary?["original_still"]?.dictionary?["url"]?.string {
            self.imageView.image = nil
            
            ImageLoader.load(from: imageUrl, completion: { image in
                if gify.id == self.id {
                    // !Important only update cell if it is still visible on screen
                    self.imageView.image = image // ?? or placholder image
                    
                } else {
                    print("cell was reused!")
                }
                
                /*
                if let image = image {
                    cache.setObject(image, forKey: NSString(string: gify.id))
                }*/
            })
        }
    }
}

// MARK: - GESTURES
extension GifyCollectionViewCell {
    
    private func configGestures() {
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:))))
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        print("did long press cell")
        
        if sender.state == .began {
            imageView.alpha = 0.5
            button.isSelected = true
        }
        
        if sender.state == .ended {
            if button.isSelected {
                delegate?.didSelectGify(self, id: id)
            } else {
                delegate?.didSelectGify(self, id: id)
            }
        }
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        
        button.isSelected = !button.isSelected
        imageView.alpha = button.isSelected ? 0.5 : 1.0
        
        if button.isSelected {
            delegate?.didSelectGify(self, id: id)
        } else {
            delegate?.didDeselectGify(self, id: id)
        }
    }
}
