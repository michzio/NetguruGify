//
//  ImageLoader.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 23/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

class ImageLoader {
    
    class func load(from url: String?, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = url, url.isNotEmpty else { return }
        
        let path = tempImagePath(url: url)
        if imageExists(at: path) {
            // Reuse cached image
            cachedLoad(from: path) { image in
                if image != nil {
                    completion(image)
                } else {
                    asyncLoad(from: url, completion: completion)
                }
            }
        } else {
            // Load image
            asyncLoad(from: url, completion: completion)
        }
    }
    
    class func cachedLoad(from path: String, completion: @escaping (UIImage?) -> Void) {
        FileCacher.load(at: path) { data in
            guard let data = data else {
                print("Invalid cached image!")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    class func asyncLoad(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        let imagePath = tempImagePath(url: urlString)
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        
        DispatchQueue(label: "image-loader", qos: .background).async {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    print("Image loader request failed!")
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                guard let data = data, error == nil else {
                    print("Image loader error: \(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                
                guard let image = UIImage(data: data) else {
                    print("Invalid image data!")
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                
                // cache image before displaying it
                FileCacher.store(data: image.pngData()!, at: imagePath)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            task.resume()
        }
    }
    
    
    // it is not suitable when used in collection view / table view where cells are reused
    class func load(imageView: UIImageView, from url: String?, placeholder: UIImage? = nil) {
        
        self.load(imageView: imageView, from: url, placeholder: placeholder) { }
    }
    
    class func load(imageView: UIImageView, from url: String?, placeholder: UIImage? = nil, completion: @escaping () -> Void) {
        
        guard let url = url,url.isNotEmpty else { return }
        
        imageView.clipsToBounds = true
        
        let wasInteractionEnabled = imageView.disableInteractions()
        
        let path = tempImagePath(url: url)
        if imageExists(at: path) {
            // Reuse cached image
            cachedLoad(imageView: imageView, from: path) { success in
                if success {
                    imageView.isUserInteractionEnabled = wasInteractionEnabled
                    completion()
                } else {
                    imageView.image = placeholder
                    asyncLoad(imageView: imageView, url: url) {
                        imageView.isUserInteractionEnabled = wasInteractionEnabled
                        completion()
                    }
                }
            }
        } else {
            imageView.image = placeholder
            
            // Load image
            asyncLoad(imageView: imageView, url: url) {
                imageView.isUserInteractionEnabled = wasInteractionEnabled
                completion()
            }
        }
    }
    
    // MARK: - HELPERS
    class func tempImagePath(url: String) -> String {
        
        let imageName = url.replacingOccurrences(of: "/", with: "")
        let imagePath = String(format: "%@/%@", NSTemporaryDirectory(), imageName)
        
        return imagePath
    }
    
    class func imageExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    // MARK: - LOAD CACHED IMAGE
    class func cachedLoad(imageView: UIImageView, from path: String, completion: @escaping (Bool) -> Void) {
        FileCacher.load(at: path) { data in
            guard let data = data else {
                print("Invalid cached image!")
                completion(false)
                return
            }
            
            imageView.image = UIImage(data: data)
            completion(true)
        }
    }
    
    // MARK: - ASYNC IMAGE LOADING
    class func asyncLoad(imageView: UIImageView, url urlString: String, completion: @escaping () -> Void) {
        
        let imagePath = tempImagePath(url: urlString)
        
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)

        
        DispatchQueue(label: "image-loader", qos: .background).async {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    print("Image loader request failed!")
                    DispatchQueue.main.async { completion() }
                    return
                }
                
                guard let data = data, error == nil else {
                    print("Image loader error: \(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async { completion() }
                    return
                }
                
                
                guard let image = UIImage(data: data) else {
                    print("Invalid image data!")
                    DispatchQueue.main.async { completion() }
                    return
                }
                
                // cache image before displaying it
                FileCacher.store(data: image.pngData()!, at: imagePath)
                
                DispatchQueue.main.async {
                    imageView.image = image
                    completion()
                }
            }
            
            task.resume()
        }
        
    }
}

extension UIImageView {
    
    func disableInteractions() -> Bool {
        let temp = self.isUserInteractionEnabled
        self.isUserInteractionEnabled = false
        return temp
    }
}
