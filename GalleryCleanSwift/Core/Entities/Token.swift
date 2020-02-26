//
//  Token.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 20.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation



struct Token: Codable {
    var access_token: String?
    var expires_in: Int?
    var token_type: String?
    var scope: Int?
    var refresh_token: String?
}
