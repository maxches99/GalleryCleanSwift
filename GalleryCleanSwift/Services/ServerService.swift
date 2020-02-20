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
    func login(mail: String, password: String)
}

class ServerService: ServerServiceProtocol {
    
    
    var urlLogin: String! = "http://gallery.dev.webant.ru/api/clients"

    let oauth2: Dictionary!  = ["name": "MaxApp","allowedGrantTypes": ["password", "refresh_token"]]
    
    var loader: OAuth2DataLoader?
    
    func login(mail: String, password: String){
        print("service")
//        if oauth2.isAuthorizing {
//            oauth2.abortAuthorization()
//            return
//        }
//        oauth2.authConfig.authorizeEmbedded = true
//        oauth2.authConfig.authorizeContext = self
//        let loader = OAuth2DataLoader(oauth2: oauth2)
//        self.loader = loader
//        print(loader)
//        loader.perform(request: userDataRequest) { response in
//            do {
//                let json = try response.responseJSON()
//                self.didGetUserdata(dict: json, loader: loader)
//            }
//            catch let error {
//                self.didCancelOrFail(error)
//            }
//        }
//
//        let sessionManager = SessionManager()
//        let retrier = OAuth2RetryHandler(oauth2: oauth2)
//        sessionManager.adapter = retrier
//        sessionManager.retrier = retrier
//    sessionManager.request("http://gallery.dev.webant.ru/api/clients").validate().responseJSON { response in
//            debugPrint(response)
//        }
            Alamofire.request(self.urlLogin, method: .post, parameters: self.oauth2, encoding: JSONEncoding.default, headers: nil)
            .response { response in
                if response.response?.statusCode == 400 {
                    print("authorisation error")

                    // you need to exit the request here since there was error and
                    // no parsing is needed further for the response
                    // you can also send and error using the observer.OnError(Error)
                    return
                }

                // convert data to our model and update the local variable
                guard let responseData =  response.data else {
                    return
                }
                do {
                    print(response.response?.statusCode)
                    print(responseData)
                    let model = try JSONDecoder().decode(User.self, from: responseData)
                    print(model)
//                    observer.onNext(model)
//                    observer.onCompleted()
                }catch {
//                    observer.onError(error)
//                    observer.onCompleted()
                    print("some thing went wrong.")
                }
        }
   
           
    
    
}
}
