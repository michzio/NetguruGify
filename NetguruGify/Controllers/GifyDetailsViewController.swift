//
//  GifyDetailsViewController.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftGifOrigin

protocol GifyDetailsDelegate : class {
    
    func isGifyStarred(_ gify: Gify) -> Bool
    func setGifyStarred(_ gify: Gify, isStarred: Bool)
}

class GifyDetailsViewController: UIViewController {
    
    var baseService = BaseService()
    var gify: Gify!
    
    var data: Data? = nil
    
    weak var delegate: GifyDetailsDelegate?
    
    private var isStarred: Bool = false {
        didSet {
            navigationItem.rightBarButtonItem?.tintColor =  isStarred ? .orange : .lightGray
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
        configBarButtons()
        
        loadGify()
        isStarred = delegate?.isGifyStarred(gify) ?? false
    }
    
    private func configViews() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        self.view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32).isActive = true
    }
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var button : UIButton = {
        let button = UIButton()
        button.setTitle("Save GIF", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitleColor(.lightGray, for: .disabled)
        
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
}

extension GifyDetailsViewController {
    
    private func loadGify() {
        
        guard let imageUrl = gify.images.dictionary?["original"]?.dictionary?["url"]?.string else {
            print("no gif in json!")
            return
        }
        
        guard let url = URL(string: imageUrl) else {
            print("gif url error!")
            return
        }
        
        baseService.get(url: url) { [weak self] (data, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { return }
                self?.data = data
                self?.button.isEnabled = true
                self?.imageView.image = UIImage.gif(data: data)
            }
        }
        
    }
}

// MARK: - SAVING GIF
extension GifyDetailsViewController {
    
    @objc func didTapButton(_ sender: UIButton) {
        
        guard let data = data else {
            print("No data of GIF!")
            return
        }
        
        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found!")
            return
        }
        let fileURL = url.appendingPathComponent("\(gify.id).gif")
    
        FileCacher.store(data: data, at: fileURL.path) { success in
            
            if success {
                //self.showAlert(title: "Success", message: "Saved GIF \(self.gify.id).gif", ok: "OK") {
                guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else { return }
                for i in 0..<contents.count {
                    if contents[i].lastPathComponent == "\(self.gify.id).gif" {
                        let activityViewController = UIActivityViewController(activityItems: [contents[i]], applicationActivities: nil)
                        self.present(activityViewController, animated: true, completion: nil)
                    }
                }
                

            } else {
                self.showAlert(title: "Error", message: "Saving failed!", ok: "OK")
            }
        }
    }
}

// MARK: - BAR BUTTONS
extension GifyDetailsViewController {
    
    private func configBarButtons() {
        
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    var barButton: UIBarButtonItem {
        
        let button = UIBarButtonItem(image: UIImage(named: "Star"), style: .plain, target: self, action: #selector(didTapStar(_:)))
        button.tintColor =  isStarred ? .orange : .lightGray
        return button
    }
    
    @objc func didTapStar(_ sender: UIBarButtonItem) {
        
        isStarred = !isStarred
        
        delegate?.setGifyStarred(gify, isStarred: isStarred)
    }
    
}
