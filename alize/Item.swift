//
//  Item.swift
//  alize
//
//  Created by Julien Delferiere on 24/03/2024.
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
