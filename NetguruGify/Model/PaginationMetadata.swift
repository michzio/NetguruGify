//
//  PaginationMetadata.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import Foundation

struct PaginationMetadata : Decodable {
    
    var totalCount : Int
    var count : Int
    var offset : Int
    
    enum CodingKeys : String, CodingKey {
        case totalCount = "total_count"
        case count = "count"
        case offset = "offset"
    }
}

extension PaginationMetadata {
    
    var pages : Int {
        return Int(ceil(Double(totalCount) / Double(count)))
    }
}
