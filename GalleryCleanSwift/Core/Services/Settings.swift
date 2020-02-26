//
//  Settings.swift
//  Scanner
//
//  Created by iOS Developer on 8/5/19.
//  Copyright © 2019 WebAnt. All rights reserved.
//

import Foundation

protocol DataStorage {
    
    var categoryBundle: CategoryBundleEntity? { get set }
    var categories: [CategoryEntity] { get set }
    var pests: [PestCommonEntity] { get set }
    var pendingRequests: [LocalRequestEntity] { get set }
}

protocol Settings: TokenStorage, DataStorage {
    
    var deviceID: Int? { get set }
    var isGeneralGuideShown: Bool { get set }
    var isCameraGuideShown: Bool { get set }
    
    func clearUserData()
}


protocol TokenStorage: class {
    
    var token: TokenEntity? { get set }
}
