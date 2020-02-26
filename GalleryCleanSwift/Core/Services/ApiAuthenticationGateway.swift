//
//  ApiAuthenticationGateway.swift
//  Scanner
//
//  Created by iOS Developer on 8/30/19.
//  Copyright © 2019 WebAnt. All rights reserved.
//

import Foundation
import RxSwift


class ApiAuthenticationGateway: BaseGateway, AuthenticationGateway {
    
    func auth(_ username: String, _ password: String) -> Single<TokenEntity> {
        return apiClient.execute(request: .loginRequest(username, password))
    }
    
    func refreshToken(_ refreshToken: String) -> Single<TokenEntity> {
        return apiClient.execute(request: .tokenRefreshRequest(refreshToken))
    }
}
