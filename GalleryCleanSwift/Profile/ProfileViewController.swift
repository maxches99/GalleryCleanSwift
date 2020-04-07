//
//  ProfileViewController.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

protocol ProfileViewProtocol: class {
    func reloadData()
    func insertItems(sequince: [IndexPath])
}

class ProfileViewController: UIViewController, ProfileViewProtocol {
    func reloadData() {
        self.collectionView.reloadData()
    }
    

    @IBOutlet weak var userBirthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    
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
    var presenter: ProfilePresenterProtocol!
    let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.value(forKey:"Profile") as? Data {
            let profile = try? PropertyListDecoder().decode(Profile.self, from: data)
            userNameLabel.text = profile?.fullName
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destination = segue.destination as? DetailViewController {
               let cell = sender as! UICollectionViewCell
               let selectedRow = collectionView.indexPath(for: cell)!.row
               presenter.goToDetail(index: selectedRow, destination: destination)
           }
       }


}
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.photos.count
        print(self.presenter.currentArray.count)
        return self.presenter.currentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photoCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "photo1", for: indexPath) as! ProfileCollectionViewCell
        presenter.setupCell(photoCell, indexPath)
        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.pagination(index: indexPath.row)
        }

}
