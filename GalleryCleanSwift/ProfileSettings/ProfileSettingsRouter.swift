//
//  ProfileSettingsRouter.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
protocol ProfileSettingsRouterProtocol {
    func closeCurrentViewController()
}

class ProfileSettingsRouter: ProfileSettingsRouterProtocol {
    weak var viewController: ProfileSettingsViewController!
    
    init(viewController: ProfileSettingsViewController) {
        self.viewController = viewController
    }
    
    func closeCurrentViewController() {
        viewController.dismiss(animated: true, completion: nil)
        viewController.performSegue(withIdentifier: "go to tabBar from profileSettings", sender: self)
    }
    
    
}
