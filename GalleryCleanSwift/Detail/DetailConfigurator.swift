//
//  DetailConfigurator.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
protocol DetailConfiguratorProtocol {
    func configure(with viewController: DetailViewController)
}

class DetailConfigurator: DetailConfiguratorProtocol {
    func configure(with viewController: DetailViewController) {
        let presenter = DetailPresenter(view: viewController)
        let interactor = DetailInteractor(presenter: presenter)
        let router = DetailRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
