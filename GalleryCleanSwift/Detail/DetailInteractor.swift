//
//  DetailInteractor.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

protocol DetailInteractorProtocol: class {
    func loadImage(url: String)
}

class DetailInteractor: DetailInteractorProtocol {
    weak var presenter: DetailPresenterProtocol!

    required init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
    }
    
    func loadImage(url: String) {
        if Connectivity.isConnectedToInternet {
            let urlPhoto = URL(string: "http://gallery.dev.webant.ru/media/" + (url))!
            RxAlamofire.requestData(.get, urlPhoto)
                .asSingle()
                .map { (response, data) -> UIImage? in
                    return UIImage(data: data)
                }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (model) in
                self.presenter.view.detailImage.image = model
            }) { (error) in
                //handle error
                print("Rx ERROR")
            }
        } else {
            print("No internet connection")
            
        }
    }
    
    
}
