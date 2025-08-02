//
//  Item.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
