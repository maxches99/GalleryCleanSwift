//
//  ProfileSettingsViewController.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import UIKit
protocol ProfileSettingsViewProtocol: class {
    
}

class ProfileSettingsViewController: UIViewController, ProfileSettingsViewProtocol {
    let configurator: ProfileSettingsConfiguratorProtocol = ProfileSettingsConfigurator()
    var presenter: ProfileSettingsPresenterProtocol!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateBirthTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.value(forKey:"Profile") as? Data {
            let profile = try? PropertyListDecoder().decode(Profile.self, from: data)
            userNameTextField.text = profile?.fullName
            emailTextField.text = profile?.email
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeView(_ sender: Any) {
        presenter.router.closeCurrentViewController()
    }
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
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
