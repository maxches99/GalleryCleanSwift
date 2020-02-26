//
//  DetailViewController.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

protocol DetailView: class {
    var inputPhoto: Photo! { get set }
    var detailImage: UIImageView! { get set }
    var imageDescription: UITextView! { get set }
    var imageUser: UILabel! { get set }
    var imageName: UILabel! { get set }
}

class DetailViewController: UIViewController, DetailView {
    var inputPhoto: Photo!
    
    var presenter: DetailPresenterProtocol!
    let configurator: DetailConfiguratorProtocol = DetailConfigurator()
    @IBOutlet weak var imageDescription: UITextView!
    @IBOutlet weak var imageUser: UILabel!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        self.presenter.congigureView(inputPhoto: inputPhoto)
        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
