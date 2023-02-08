//
//  GifyService.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import Foundation

class GifyService : BaseService, GifyServiceInterface {
    
    public func getGifyData(offset: Int = 0, completion: ((GifyData?, Error?) -> Void)? = nil) {
        
        guard var urlComponents = URLComponents(string: Settings.apiUrl) else { return }
        urlComponents.query = "api_key=\(Settings.apiKey)&offset=\(offset)"
        guard let url = urlComponents.url else { return }
        
        get(url: url, completion: completion)
       
    }
}
