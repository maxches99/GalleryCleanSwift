//
//  BaseGateway.swift
//  Scanner
//
//  Created by iOS Developer on 8/7/19.
//  Copyright © 2019 WebAnt. All rights reserved.
//

import Foundation
import RxNetworkApiClient

class BaseGateway {
    
    internal let apiClient: ApiClient
    
    init(_ apiClient: ApiClient) {
        self.apiClient = apiClient
    }
}
