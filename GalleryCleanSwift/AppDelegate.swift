//
//  AppDelegate.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 18.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import UIKit
import Alamofire
import RxAlamofire
import p2_OAuth2
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var urlLogin: String! = "http://gallery.dev.webant.ru/api/clients"

    let oauth2: Dictionary!  = ["name": "MaxApp","allowedGrantTypes": ["password", "refresh_token"]]
    
    var loader: OAuth2DataLoader?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Alamofire.request(self.urlLogin, method: .post, parameters: self.oauth2, encoding: JSONEncoding.default, headers: nil)
                    .response { response in
                        if response.response?.statusCode == 400 {
                            print("authorisation error")
                            return
                        }
                        guard let responseData =  response.data else {
                            return
                        }
                        do {
                            print(response.response?.statusCode)
                            print(responseData)
                            let model = try JSONDecoder().decode(User.self, from: responseData)
                            print(model)
                            let defaults = UserDefaults.standard
                            defaults.set(model.id, forKey: "Id")
                            defaults.set(model.secret, forKey: "ClientSecret")
                            defaults.set(model.randomId, forKey: "Random")
                        }catch {
                            print("some thing went wrong.")
                        }
                }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    


}

