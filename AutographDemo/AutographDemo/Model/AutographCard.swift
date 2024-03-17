//
//  AutographCard.swift
//  AutographDemo
//
//  Created by Jens Troest on 3/11/24.
//

import SwiftData
import SwiftUI
@Model
class AutoGraphCard {
    var signature: [[CGPoint]]
    var name: String?
    let creationDate: Date
    
    init(signature: [[CGPoint]] = [], name: String? = nil, created: Date = .now) {
        self.signature = signature
        self.name = name
        self.creationDate = created
        
    }
    
    var isEmpty: Bool {
        signature.isEmpty
    }
    
    /// A wrapper providing a non optional string binding for `name`
    var nameBinding: Binding<String> {
        Binding(
            get: { self.name ?? "" },
            set: { self.name = $0.isEmpty ? nil : $0 }
        )
    }
}
