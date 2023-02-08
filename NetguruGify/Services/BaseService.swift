//
//  BaseService.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import Foundation

class BaseService {
    
    let session =  URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    
    func get<T : Decodable>(url: URL, completion: ((T?, Error?) -> Void)? = nil ) {
        
        self.get(url: url) { [weak self] (data, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
            } else if let data = data {
                
                do {
                    let object = try self?.decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion?(object, nil)
                    }
                    return
                } catch(let error) {
                    print("Error decoding: \(error)")
                }
                DispatchQueue.main.async {
                    completion?(nil, nil)
                }
            }
        }
    }
    
    func get(url: URL, completion: ((Data?, Error?) -> Void)? = nil ) {
       
        print("request to: \(url.absoluteString)")
        
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            
            defer {
                self?.dataTask = nil
            }
            
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                completion?(data, error)
            } else {
                completion?(nil, error)
            }
        }
        
        dataTask?.resume()
    }
    
    open var decoder : JSONDecoder {
        return JSONDecoder()
    }
}
