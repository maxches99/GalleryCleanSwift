//
//  MainViewController.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import RxSwift
import RxAlamofire
import MaterialComponents.MaterialActivityIndicator

protocol MainViewProtocol: class {
    func reloadData()
    func insertItems(sequince: [IndexPath])
}

class MainViewController: UIViewController, MainViewProtocol, UITextFieldDelegate {

    

    // MARK: Var/Let
    var currentPage: Int! = 1
    var isNewDataLoading: Bool! = false
    private var photos: [UIImage] = []
    private var descriptions: [String] = []
    private var urls: [String] = []
    private let refreshControl = UIRefreshControl()
    var origin: Origin!
    private var currentArray: [Photo]! = []

    var flag_inactiveInternet: Bool! = false
    
    // MARK: PhotosURL
    // our url for api
    
    
    var presenter: MainPresenterProtocol!
    let configurator: MainConfiguratorProtocol = MainConfigurator()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.congigureView()
        //loadImage()
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshCollection(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        loadCustomRefreshContents()
        UserDefaults.standard.set(0,forKey: "currentState")
        searchField.delegate = self
    
    }
    func reloadData() {
        collectionView.reloadData()
    }
    func insertItems(sequince: [IndexPath]){
        collectionView.insertItems(at: sequince)
    }
    // MARK: RefreshController
    @objc private func refreshCollection(_ sender: Any) {
        if Connectivity.isConnectedToInternet {
            if flag_inactiveInternet {
                self.presenter.congigureView()
                self.flag_inactiveInternet = false
                
            }
            collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
        else {
            //print("No internet")
            self.flag_inactiveInternet = true
            self.currentArray.removeAll()
            self.currentPage = 1
            collectionView.reloadData()
            print("no internet")
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadCustomRefreshContents() {
        refreshControl.tintColor = UIColor.clear
        let activityIndicator2 = MDCActivityIndicator()
        activityIndicator2.cycleColors = [.blue, .red, .green, .yellow]
        activityIndicator2.tintColor = .red
        activityIndicator2.sizeToFit()
        activityIndicator2.indicatorMode = .indeterminate
        activityIndicator2.startAnimating()
        let customView = activityIndicator2 as UIView
        customView.frame = refreshControl.bounds
        refreshControl.addSubview(customView)
    }
    @IBAction func changeSegment(_ sender: Any) {
        print(segmentedControl.selectedSegmentIndex)
        presenter.changeSegment(segmentRow: segmentedControl.selectedSegmentIndex)
        collectionView.reloadData()
//        currentPage = 1
//        currentArray.removeAll()
//        loadImage()
//        collectionView.reloadData()
        
    }
    
    @IBAction func searching(_ sender: Any) {
        self.view.endEditing(true)
        presenter.searchAct(search: self.searchField.text!)
    }
    
    static func storyboardInstance() -> MainViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainViewController
    }
//    func loadImage() {
//        if Connectivity.isConnectedToInternet {
//            let url = URL(string: photosURL + String(self.currentPage) + "&limit=15")!
//            isNewDataLoading = true
//            RxAlamofire.requestData(.get, url)
//                .asSingle()
//                .map { (response, data) -> Origin in
//                    //                   print("Response: \(response)")
//                                        print("Data: \(data)")
//
//                    return try! JSONDecoder().decode(Origin.self, from: data)
//            }
//            .observeOn(MainScheduler.instance)
//            .subscribe(onSuccess: { [weak self] (model) in
//                //
//                guard let self = self else {
//                    return
//                }
//                self.origin = model
//                let startIndex = self.currentArray.count
//                let endIndex = self.currentArray.count + self.origin.data.count
//                let sequince = (startIndex..<endIndex).map{IndexPath(item: $0, section: 0)}
//                self.currentArray.append(contentsOf: self.origin.data)
//                print(self.currentArray)
//                if self.currentPage == 1 {
//                    self.collectionView.reloadData()
//                    print("reload data")
//                    print(self.photosURL)
//                } else {
//                    self.collectionView.insertItems(at: sequince)
//                }
//                self.isNewDataLoading = false
//            }) { (error) in
//                print("Rx ERROR")
//            }
//        } else {
//            print("No internet connection")
//        }
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            let cell = sender as! UICollectionViewCell
            let selectedRow = collectionView.indexPath(for: cell)!.row
            presenter.goToDetail(index: selectedRow, destination: destination)
        }
    }
    

}
//extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //return self.photos.count
//        return presenter.numberOfRows
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let photoCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as! MainCollectionViewCell
//        presenter.setupCell(photoCell, indexPath)
//        return photoCell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        presenter.onCellSelected(indexPath)
//    }
//
//    // MARK: Pagination
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == self.currentArray.count - 5, !self.isNewDataLoading {
//            self.updateNextSet()
//        }
//    }
//
//    func updateNextSet() {
//        if currentPage < self.origin.countOfPages {
//            self.isNewDataLoading = true
//            self.currentPage += 1
//            self.loadImage()
//        }
//    }
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.photos.count
        return self.presenter.currentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photoCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as! MainCollectionViewCell
        presenter.setupCell(photoCell, indexPath)
        return photoCell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let destination = segue.destination as? DetailViewController {
//            let cell = sender as! UICollectionViewCell
//            let selectedRow = collectionView.indexPath(for: cell)!.row
//            destination.bigImageOr = posts[selectedRow].imageC
//            destination.nameIm = posts[selectedRow].title
//            destination.descriptionIm = posts[selectedRow].description
//        }
//        presenter.goToDetail(index: indexPath.row)
//    }
    // MARK: Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.pagination(index: indexPath.row)
        }
//
//    func updateNextSet() {
//        if currentPage < self.origin.countOfPages {
//            self.isNewDataLoading = true
//            self.currentPage += 1
//            self.loadImage()
//        }
//    }
}

