//
//  User.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int?
    let name: String?
    let randomId: String?
    var secret: String?
    var allowedGrantTypes: [String]?
}

struct AllowedGrantTypes: Codable {
    var password: String
    var refresh_token: String
}

struct BeginUser: Codable {
    let name: String
    let allowedGrantTypes: [String]
    

}

struct TokenError: Codable {
    var error: String?
    var error_description: String?
}

struct Profile: Codable {
    let id: Int?
    var email: String?
    var enabled: Bool?
    var phone: String?
    var fullName: String?
    var username: String?
    var roles: [String]?
}
