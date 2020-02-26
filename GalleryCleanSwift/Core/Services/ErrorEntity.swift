//
//  ErrorEntity.swift
//  Scanner
//
//  Created by iOS Developer on 8/5/19.
//  Copyright © 2019 WebAnt. All rights reserved.
//

import Foundation

struct ErrorEntity: LocalizedError, Codable {
    
    var errors = [String]()
    var code: Int = 0
    var errorDescription: String? {
        return errors.joined(separator: ". ")
    }
    
    init() {
    }
    
    init(_ message: String, _ code: Int = 0) {
        self.code = code
        self.errors = [message]
    }
    
    mutating func addMessage(_ message: String) {
        errors.append(message)
    }

}
