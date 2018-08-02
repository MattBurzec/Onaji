//
//  Array.swift
//  Onaji
//
//  Created by Matthew  Burzec on 8/2/18.
//  Copyright © 2018 Matthew Burzec. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}
