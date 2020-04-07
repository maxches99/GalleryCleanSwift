//
//  ProfilePresenter.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
import Kingfisher

protocol ProfilePresenterProtocol: class {
    var router: ProfileRouterProtocol! { set get }
    var view: ProfileViewProtocol! { get set }
    func congigureView()
    var numberOfRows: Int! { get }
    func setupCell(_ cell: ProfileCollectionViewCell, _ indexPath: IndexPath)
    func onCellSelected(_ indexPath: IndexPath)
    var currentArray: [Photo]! { get set }
    func pagination(index: Int)
    var isNewDataLoading: Bool! { get set }
    var origin: Origin! { get set }
    func goToDetail(index: Int, destination: DetailViewController)
}

class ProfilePresenter: ProfilePresenterProtocol {

    

    
    var isNewDataLoading: Bool! = false
    var segment: Int! = 0
    
    
    
    func onCellSelected(_ indexPath: IndexPath) {
        
    }
    
    func setupCell(_ cell: ProfileCollectionViewCell, _ indexPath: IndexPath) {
        print(currentArray[indexPath.row].image)
        let url = URL(string: "http://gallery.dev.webant.ru/media/" + currentArray[indexPath.row].image.name)
        cell.photo.kf.indicatorType = .activity
        cell.photo.kf.setImage(with: url)
        print(url)
        cell.photo.layer.cornerRadius = 12
        print(indexPath.row)
    }
    
    var numberOfRows: Int! = 1
    
    
    weak var view: ProfileViewProtocol!
    var interactor: ProfileInteractorProtocol!
    var router: ProfileRouterProtocol!
    var origin: Origin!
    var currentArray: [Photo]! = []
    var currentPage: Int! = 1
    required init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func congigureView() {
        self.interactor.loadImages(currentPage: currentPage, currentState: 0)
    }
    
    
    
    func updateNextSet() {
        if currentPage < self.origin.countOfPages {
            self.isNewDataLoading = true
            self.currentPage += 1
            self.interactor.loadImages(currentPage: currentPage, currentState: UserDefaults.standard.integer(forKey: "currentState"))
            print("pagination \(UserDefaults.standard.integer(forKey: "currentState"))")
        }
    }
    func pagination(index: Int) {
        if index == self.currentArray.count - 5, !self.isNewDataLoading {
            updateNextSet()
        }
}
    func goToDetail(index: Int, destination: DetailViewController) {
           self.router.goToDetail(currentElement: currentArray[index], destination: destination)
       }
    
//    func goToDetail(index: Int, destination: DetailViewController) {
//        self.router.goToDetail(currentElement: currentArray[index], destination: destination)
//    }
}


