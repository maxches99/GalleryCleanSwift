//
//  AuthInterceptor.swift
//  Scanner
//
//  Created by iOS Developer on 8/5/19.
//  Copyright © 2019 WebAnt. All rights reserved.
//

import Foundation
import RxNetworkApiClient

/// Добавляет к каждому запросу заголовок авторизации, если есть токен авторизации.
class AuthInterceptor: Interceptor {
    
    private let tokenStorage: TokenStorage
    
    init(_ tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
    
    func prepare<T: Codable>(request: ApiRequest<T>) {
        guard request.path == nil || request.path != "/api/clients" else {
            return
        }
        let authHeaderKey = "Authorization"
        let index = request.headers?.firstIndex(where: { $0.key == authHeaderKey})
        if let auth = tokenStorage.token?.access_token {
            let authHeader = Header(authHeaderKey, "Bearer \(auth)")
            if index == nil {
                if request.headers == nil {
                    request.headers = [authHeader]
                } else {
                    request.headers!.append(authHeader)
                }
            } else {
                request.headers![index!] = authHeader
            }
        }
    }
    
    func handle<T: Codable>(request: ApiRequest<T>,
                            response: NetworkResponse) {
        // empty
    }
}
