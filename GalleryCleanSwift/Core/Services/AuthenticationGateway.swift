//
//  AuthenticationGateway.swift
//  Scanner
//
//  Created by iOS Developer on 8/5/19.
//  Copyright © 2019 WebAnt. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthenticationGateway {
    
    func auth(_ username: String, _ password: String) -> Single<TokenEntity>
    func refreshToken(_ refreshToken: String) -> Single<TokenEntity>
//    func sendCaptcha(_ file: String, code: String) -> Completable
//    func getAccount() -> Single<UserModel>
}
