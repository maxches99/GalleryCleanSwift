//
//  TokenEntity.swift
//  Scanner
//
//  Created by iOS Developer on 8/5/19.
//  Copyright © 2019 WebAnt. All rights reserved.
//

import Foundation

struct TokenEntity: Codable {
    
    var access_token: String
    var refresh_token: String
    
    
    init(accessToken: String, refreshToken: String) {
        self.access_token = accessToken
        self.refresh_token = refreshToken
    }
}
