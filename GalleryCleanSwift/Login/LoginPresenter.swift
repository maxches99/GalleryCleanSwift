//
//  LoginPresenter.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol: class {
    var router: LoginRouterProtocol! { set get }
    func congigureView()
    func loginButtonClicked(mail: String, password: String)
}

class LoginPresenter: LoginPresenterProtocol {
    
    weak var view: LoginViewProtocol!
    var interactor: LoginInteractorProtocol!
    var router: LoginRouterProtocol!
    
    required init(view: LoginViewProtocol) {
        self.view = view
    }
    
    func congigureView() {
        
    }
    
    func loginButtonClicked(mail: String, password: String) {
        print("presenter")
        interactor.loginUrl(mail: mail, password: password)
    }
    
    
}
