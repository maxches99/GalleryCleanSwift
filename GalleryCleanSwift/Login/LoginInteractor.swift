//
//  LoginInteractor.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

protocol LoginInteractorProtocol: class {
    func loginUrl(mail: String, password: String) -> String
}

class LoginInteractor: LoginInteractorProtocol {
    
    let serverService: ServerServiceProtocol = ServerService()

    weak var presenter: LoginPresenterProtocol!
    
    required init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
    
    func loginUrl(mail: String, password: String) -> String {
        print("interactor")
        return serverService.login(mail: mail, password: password)
    }
}
