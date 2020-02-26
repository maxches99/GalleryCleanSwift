//
//  MainRouter.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

protocol MainRouterProtocol {
    func closeCurrentViewController()
    func goToDetail(currentElement: Photo, destination: DetailViewController)
}

class MainRouter: MainRouterProtocol {

    

    
    weak var viewController: MainViewController!
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func closeCurrentViewController() {
        viewController.dismiss(animated: true, completion: nil)
        viewController.performSegue(withIdentifier: "firstStep", sender: self)
    }
    
    func goToDetail(currentElement: Photo, destination: DetailViewController) {
        destination.inputPhoto = currentElement
    }
    
    
}
