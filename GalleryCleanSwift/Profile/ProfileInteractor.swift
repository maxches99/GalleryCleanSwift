//
//  ProfileInteractor.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//


import Foundation
import RxAlamofire
import RxSwift

protocol ProfileInteractorProtocol: class {
    var origin: Origin! { get set}
    func loadImages(currentPage: Int, currentState: Int)
}

class ProfileInteractor: ProfileInteractorProtocol {
    var currentElement: Photo!
    
    
    var isNewDataLoading: Bool! = false
    let serverService: ServerServiceProtocol = ServerService()
    var origin: Origin!
    private var currentArray: [Photo]! = []
    weak var presenter: ProfilePresenterProtocol!

    required init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    func loadImages(currentPage: Int, currentState: Int) {
        var photosURL = "http://gallery.dev.webant.ru/api/photos?user.id=\(UserDefaults.standard.integer(forKey: "user_id"))"
        
               let url = URL(string: photosURL + "&page=" + String(currentPage) + "&limit=15")!
        print(url)
        self.presenter.isNewDataLoading = true
               RxAlamofire.requestData(.get, url)
                   .asSingle()
                   .map { (response, data) -> Origin in
                       //                   print("Response: \(response)")
                                           print("Data: \(data), it is photos")
                       
                       return try! JSONDecoder().decode(Origin.self, from: data)
               }
               .observeOn(MainScheduler.instance)
               .subscribe(onSuccess: { [weak self] (model) in
                   guard let self = self else {
                       return
                   }
                   self.origin = model
                
                   let startIndex = self.presenter.currentArray.count
                   let endIndex = self.presenter.currentArray.count + self.origin.data.count
                   let sequince = (startIndex..<endIndex).map{IndexPath(item: $0, section: 0)}
                   print(sequince)
                   self.presenter.isNewDataLoading = false
                   self.presenter.currentArray.append(contentsOf: self.origin.data)
                
                self.presenter.origin = model
                if currentPage == 1 {
                    self.presenter.view.reloadData()
                    print("reloadData")
                }
                else {
                    self.presenter.view.insertItems(sequince: sequince)
                }
               }) { (error) in
                   //handle error
                   print("Rx ERROR")
               }
       }
}
