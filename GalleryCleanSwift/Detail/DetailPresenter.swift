//
//  DetailPresenter.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation

protocol DetailPresenterProtocol: class {
    var router: DetailRouterProtocol! { set get }
    var view: DetailView! { get set }
    func congigureView(inputPhoto: Photo)
}

class DetailPresenter: DetailPresenterProtocol {
    
    weak var view: DetailView!
    required init(view: DetailView) {
        self.view = view
    }
    var interactor: DetailInteractorProtocol!
    var router: DetailRouterProtocol!
    func congigureView(inputPhoto: Photo) {
        self.interactor.loadImage(url: inputPhoto.image.name)
        self.view.imageName.text = inputPhoto.name
        self.view.imageDescription.text = inputPhoto.description
        self.view.imageUser.text = inputPhoto.user
    }
    
}
