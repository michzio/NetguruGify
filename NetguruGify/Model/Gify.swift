//
//  Gify.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GifyData : Decodable {
    
    var data : [Gify]
    var pagination : PaginationMetadata
}

struct Gify : Decodable {
    
    var id : String
    var title : String
    var images : JSON
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case images
        case type
    }
}

extension Gify : Equatable {

    static func == (lhs: Gify, rhs: Gify) -> Bool {
        
        return lhs.id == rhs.id
    }
    
}

