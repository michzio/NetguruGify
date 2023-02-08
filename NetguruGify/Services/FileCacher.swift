//
//  ImageCacher.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 23/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import Foundation

class FileCacher {
    
    class func store(data: Data, at path: String, completion: ((Bool) -> Void)? = nil) {
    
        DispatchQueue(label: "file-cacher", qos: .background).async {
            do {
                try data.write(to: URL(fileURLWithPath: path), options: [])
                
                DispatchQueue.main.async {
                     completion?(true)
                }
            } catch let error as NSError {
                print("Failed to save image. \(error)")
                DispatchQueue.main.async {
                    completion?(false)
                }
            } catch {
                fatalError()
            }
        }
        
    }
    
    class func load(at path: String, completion: @escaping (Data?) -> Void) {
        
        DispatchQueue(label: "file-cacher", qos: .background).async {
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            DispatchQueue.main.async {
                 completion(data)
            }
        }
        
    }
}
