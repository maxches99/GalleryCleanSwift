//
//  ProfileConfigurator.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
protocol ProfileConfiguratorProtocol {
    func configure(with viewController: ProfileViewController)
}

class ProfileConfigurator: ProfileConfiguratorProtocol {
    func configure(with viewController: ProfileViewController) {
        let presenter = ProfilePresenter(view: viewController)
        let interactor = ProfileInteractor(presenter: presenter)
        let router = ProfileRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
