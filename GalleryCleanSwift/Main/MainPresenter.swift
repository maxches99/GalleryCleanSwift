//
//  MainPresenter.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
import Kingfisher

protocol MainPresenterProtocol: class {
    var router: MainRouterProtocol! { set get }
    var view: MainViewProtocol! { get set }
    func congigureView()
    var numberOfRows: Int! { get }
    func setupCell(_ cell: MainCollectionViewCell, _ indexPath: IndexPath)
    func onCellSelected(_ indexPath: IndexPath)
    func changeSegment(segmentRow: Int)
    var currentArray: [Photo]! { get set }
    func pagination(index: Int)
    var isNewDataLoading: Bool! { get set }
    var origin: Origin! { get set }
    func goToDetail(index: Int, destination: DetailViewController)
    func searchAct(search: String)
}

class MainPresenter: MainPresenterProtocol {

    

    var stringSearch: String?
    var isNewDataLoading: Bool! = false
    var segment: Int! = 0
    func changeSegment(segmentRow: Int) {
        UserDefaults.standard.set(segmentRow,forKey: "currentState")
        currentArray.removeAll()
        currentPage = 1
        self.interactor.loadImages(currentPage: currentPage, currentState: segmentRow, search: stringSearch ?? "")
    }
    
    
    
    func onCellSelected(_ indexPath: IndexPath) {
        
    }
    
    func setupCell(_ cell: MainCollectionViewCell, _ indexPath: IndexPath) {
        let url = URL(string: "http://gallery.dev.webant.ru/media/" + currentArray[indexPath.row].image.name)
        cell.photo.kf.indicatorType = .activity
        cell.photo.kf.setImage(with: url)
        cell.photo.layer.cornerRadius = 12
        print(indexPath.row)
    }
    
    var numberOfRows: Int! = 1
    
    
    weak var view: MainViewProtocol!
    var interactor: MainInteractorProtocol!
    var router: MainRouterProtocol!
    var origin: Origin!
    var currentArray: [Photo]! = []
    var currentPage: Int! = 1
    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func congigureView() {
        self.interactor.loadImages(currentPage: currentPage, currentState: 0, search: "")
    }
    
    func searchAct(search: String) {
        self.interactor.loadImages(currentPage: currentPage, currentState: UserDefaults.standard.integer(forKey: "currentState"), search: search)
    }
    
    
    func updateNextSet() {
        if currentPage < self.origin.countOfPages {
            self.isNewDataLoading = true
            self.currentPage += 1
            self.interactor.loadImages(currentPage: currentPage, currentState: UserDefaults.standard.integer(forKey: "currentState"), search: stringSearch ?? "")
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
}


