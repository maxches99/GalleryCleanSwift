//
//  MainInteractor.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift

protocol MainInteractorProtocol: class {
    var origin: Origin! { get set}
    func loadImages(currentPage: Int, currentState: Int, search: String)
}

class MainInteractor: MainInteractorProtocol {
    var currentElement: Photo!
    
    
    var isNewDataLoading: Bool! = false
    let serverService: ServerServiceProtocol = ServerService()
    var origin: Origin! 
    private var currentArray: [Photo]! = []
    weak var presenter: MainPresenterProtocol!
    var url: URL?
    required init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func loadImages(currentPage: Int, currentState: Int, search: String) {
        var photosURL = ""
        if currentState == 0 {
            photosURL = "http://gallery.dev.webant.ru/api/photos?new=true&page="
            if search != "" {
                photosURL = "http://gallery.dev.webant.ru/api/photos?name=" + search + "&new=true&page="
                print("http://gallery.dev.webant.ru/api/photos?name=" + search + "&new=true&page=")
                print(url)
            }
        }
        else {
            photosURL = "http://gallery.dev.webant.ru/api/photos?popular=true&page="
            if search != "" {
                photosURL = "http://gallery.dev.webant.ru/api/photos?name=" + search + "&popular=true&page="
                print("http://gallery.dev.webant.ru/api/photos?name=" + search + "&popular=true&page=")
                print(url)
            }
        }
        if search != "" {
            print("http://gallery.dev.webant.ru/api/photos?name=" + search)
            url = URL(string: photosURL + String(currentPage) + "&limit=15")!
            print(url)
        } else {
            url = URL(string: photosURL + String(currentPage) + "&limit=15")!
            
        }
               
        self.presenter.isNewDataLoading = true
        RxAlamofire.requestData(.get, url!)
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
                if search != "" {
                    self.presenter.currentArray.removeAll()
                    self.presenter.currentArray.append(contentsOf: self.origin!.data)
                    print(self.presenter.currentArray)
                } else {
                    self.presenter.currentArray.append(contentsOf: self.origin.data)
                }
                self.presenter.origin = model
                if currentPage == 1 {
                    self.presenter.view.reloadData()
                }
                else {
                    if search != "" {
                        self.presenter.view.reloadData()
                    }
                    else {
                        self.presenter.view.insertItems(sequince: sequince)
                        
                    }
                    
                }
               }) { (error) in
                   //handle error
                   print("Rx ERROR")
               }
       }
}
