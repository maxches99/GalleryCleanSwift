//
//  ProfileSettingsConfigurator.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
protocol ProfileSettingsConfiguratorProtocol {
    func configure(with viewController: ProfileSettingsViewController)
}

class ProfileSettingsConfigurator: ProfileSettingsConfiguratorProtocol {
    func configure(with viewController: ProfileSettingsViewController) {
        let presenter = ProfileSettingsPresenter(view: viewController)
        let interactor = ProfileSettingsInteractor(presenter: presenter)
        let router = ProfileSettingsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
