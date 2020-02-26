//
//  ServerService.swift
//  GalleryCleanSwift
//
//  Created by Максим Чесников on 19.02.2020.
//  Copyright © 2020 Максим Чесников. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import p2_OAuth2
import OAuthSwift

protocol ServerServiceProtocol {
    var profile: Profile! { get set }
    func login(mail: String, password: String)
}

class ServerService: ServerServiceProtocol {
    var origin: Origin!
    private var currentArray: [Photo]! = []
    var currentPage: Int! = 1
    var profile: Profile!
    var token: Token!
        var isNewDataLoading: Bool! = false
    private var photosURL: String! {
        get {
            if UserDefaults.standard.integer(forKey: "currentState") == 0 {
                return "http://gallery.dev.webant.ru/api/photos?new=true&page="
            }
            else {
                return "http://gallery.dev.webant.ru/api/photos?popular=true&page="
            }
        }
    }
    
    
    func login(mail: String, password: String){
        print("service")
        
        let defaults = UserDefaults.standard
        let clientId = String(defaults.integer(forKey: "Id"))
        let clientR = defaults.string(forKey: "Random")
        let clientSecret = defaults.string(forKey: "ClientSecret")
        let stringa = "http://gallery.dev.webant.ru/oauth/v2/token?client_id=\(clientId + "_" + clientR!)&grant_type=password&username=\(mail)&password=\(password)&client_secret=\(clientSecret!)"
        let urlLogin2 = URLComponents(string: stringa)
        Alamofire.request(urlLogin2!, method: .get)
            .response { response in
                if response.response?.statusCode == 400 {
                    do {
                        let model = try JSONDecoder().decode(TokenError.self, from: response.data!)
                        print(model.error_description)
                        
                    }
                    catch {
                        print("some thing went wrong.1")
                    }
                    return
                }
                if let responseData =  response.data {
                    print(response.response?.statusCode)
                    let token = String(data: responseData, encoding: .utf8)
                    let tokkenStruct = try! JSONDecoder().decode(Token.self, from: responseData)
                    self.token = tokkenStruct
                    print(tokkenStruct)
//                    defaults.set(tokkenStruct, forKey: "Tokken")
                    defaults.set(tokkenStruct.access_token, forKey: "access_token")
                    defaults.set(tokkenStruct.refresh_token, forKey: "refresh_token")
                    self.fetchUser()
                }}}
                    
                
        
    
    func fetchUser() {
        let defaults = UserDefaults.standard
        let url = URLComponents(string: "http://gallery.dev.webant.ru/api/users/current")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.token.access_token!)",
        ]
        Alamofire.request(url!, method: .get, headers: headers).response { response in
                       if response.response?.statusCode == 400 {
                          print("400")
                           return
                       }
                       if let responseData =  response.data {
                           print(response.response?.statusCode)
                           let model = try! JSONDecoder().decode(Profile.self, from: responseData)
                           self.profile = model
                        print(self.profile)
                        defaults.set(try? PropertyListEncoder().encode(model), forKey: "Profile")
                       }}
    }
    

    
    
    
}
