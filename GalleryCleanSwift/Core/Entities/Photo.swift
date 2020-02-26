//
//  Photo.swift
//  Gallery2
//
//  Created by Максим Чесников on 05.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
import Alamofire

struct Photo: Codable {
    let id: Int
    let name: String?
    let description: String?
    let new: Bool?
    let popular: Bool?
    let image: Image
    let user: String?
}

struct Image: Codable {
    let id: Int
    let name: String
}
struct Origin: Codable {
    let totalItems: Int
    let itemsPerPage: Int
    let countOfPages: Int
    let data: [Photo]
}

enum PhotoError: Error {
    case ConvertToData
    case PhotoDecoding
    case downloadPhotoUrl
    case downloadPhotoConvertToData
    case downloadPhotoConvertToUIImage
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
