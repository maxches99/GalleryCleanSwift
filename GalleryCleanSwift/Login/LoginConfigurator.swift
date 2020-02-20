//
//  LoginConfigurator.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

protocol LoginConfiguratorProtocol {
    func configure(with viewController: LoginViewController)
}

class LoginConfigurator: LoginConfiguratorProtocol {
    func configure(with viewController: LoginViewController) {
        let presenter = LoginPresenter(view: viewController)
        let interactor = LoginInteractor(presenter: presenter)
        let router = LoginRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
