//
//  ProfileSettingsInteractor.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

protocol ProfileSettingsInteractorProtocol: class {
    func loginUrl(mail: String, password: String)
}

class ProfileSettingsInteractor: ProfileSettingsInteractorProtocol {
    
    let serverService: ServerServiceProtocol = ServerService()

    weak var presenter: ProfileSettingsPresenterProtocol!
    
    required init(presenter: ProfileSettingsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func loginUrl(mail: String, password: String) {
        print("interactor")
        serverService.login(mail: mail, password: password)
        presenter.router.closeCurrentViewController()
    }
}
