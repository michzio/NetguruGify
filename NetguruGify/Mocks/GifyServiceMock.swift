//
//  GifyServiceMoxk.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 23/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import Foundation

protocol GifyServiceInterface {
    func getGifyData(offset: Int, completion: ((GifyData?, Error?) -> Void)?)
}

class GifyServiceMock : GifyServiceInterface {
    
    var data: Data?
    var error: Error?
    
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    func getGifyData(offset: Int, completion: ((GifyData?, Error?) -> Void)?) {
        
        let gifyData = try? JSONDecoder().decode(GifyData.self, from: data!)
        
        completion?(gifyData, error)
    }
}
