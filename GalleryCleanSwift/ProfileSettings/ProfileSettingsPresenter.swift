//
//  ProfileSettingsPresenter.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

protocol ProfileSettingsPresenterProtocol: class {
    var router: ProfileSettingsRouterProtocol! { set get }
    func congigureView()
    func loginButtonClicked(mail: String, password: String)
}

class ProfileSettingsPresenter: ProfileSettingsPresenterProtocol {
    
    weak var view: ProfileSettingsViewProtocol!
    var interactor: ProfileSettingsInteractorProtocol!
    var router: ProfileSettingsRouterProtocol!
    
    required init(view: ProfileSettingsViewProtocol) {
        self.view = view
    }
    
    func congigureView() {
        
    }
    
    func loginButtonClicked(mail: String, password: String) {
        print("presenter")
        interactor.loginUrl(mail: mail, password: password)
    }
    
    
}
