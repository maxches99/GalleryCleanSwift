//
//  LoginViewController.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import UIKit

protocol LoginViewProtocol: class {
    var uncorrectPassword: UILabel! { get set }
}

class LoginViewController: UIViewController, LoginViewProtocol, UITextFieldDelegate {

    var presenter: LoginPresenterProtocol!
    let configurator: LoginConfiguratorProtocol = LoginConfigurator()
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var uncorrectPassword: UILabel!
    @IBOutlet weak var theScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.congigureView()
        mailTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        theScrollView.contentOffset = CGPoint(x:0, y:keyboardFrame.size.height - 100)
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        theScrollView.contentOffset = .zero
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        presenter.loginButtonClicked(mail: mailTextField.text!, password: passwordTextField.text!)
        print("view")
    }

    @IBAction func exitMail(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func exitPassword2(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func exitPassword(_ sender: Any) {
        self.view.endEditing(true)
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
