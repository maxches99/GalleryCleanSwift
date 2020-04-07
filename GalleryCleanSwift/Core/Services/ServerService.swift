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
import RxNetworkApiClient
import UIKit
import PromiseKit

protocol ServerServiceProtocol {
    var profile: Profile! { get set }
    func login(mail: String, password: String) -> String
}
public typealias FormDataFields = Dictionary<String, Any?>

class ServerService: ServerServiceProtocol {
    var origin: Origin!
    var formData: FormDataFields?
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
    
    
    func login(mail: String, password: String) -> String{
        print("service")
        var returnString = "OK"
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
                        returnString = String(model.error_description!)
                        
                    }
                    catch {
                        print("some thing went wrong.1")
                    }
                    return
                }
                if let responseData =  response.data {
                    returnString = "OK"
                    print(response.response?.statusCode)
                    let token = String(data: responseData, encoding: .utf8)
                    let tokkenStruct = try! JSONDecoder().decode(Token.self, from: responseData)
                    self.token = tokkenStruct
                    print(tokkenStruct)
                    //                    defaults.set(tokkenStruct, forKey: "Tokken")
                    defaults.set(tokkenStruct.access_token, forKey: "access_token")
                    defaults.set(tokkenStruct.refresh_token, forKey: "refresh_token")
                    
                    self.fetchUser()
                    
                }}
        return returnString
    }
    
    
    
    
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
                defaults.set(model.id, forKey: "user_id")
            }}
    }
    
    func refresh() {
        let defaults = UserDefaults.standard
        let clientId = String(defaults.integer(forKey: "Id"))
        let clientR = defaults.string(forKey: "Random")
        var refreshToken = defaults.string(forKey: "refresh_token")
        let clientSecret = defaults.string(forKey: "ClientSecret")
        let stringa = "http://gallery.dev.webant.ru/oauth/v2/token?client_id=\(clientId + "_" + clientR!)&grant_type=refresh_token&refresh_token=\(refreshToken!)&client_secret=\(clientSecret!)"
        let urlLogin2 = URLComponents(string: stringa)!
        print(urlLogin2)
        Alamofire.request(urlLogin2, method: .get)
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
                    defaults.set(tokkenStruct.access_token, forKey: "access_token")
                    defaults.set(tokkenStruct.refresh_token, forKey: "refresh_token")
                    
                }}
    }
    
    func uploadImage(image: UIImage, act: UIActivityIndicatorView, namePost: String, description: String){
        
        let access_token = UserDefaults.standard.string(forKey: "access_token")

        var request = URLRequest(url: URL(string: "http://gallery.dev.webant.ru/api/media_objects")!,timeoutInterval: Double.infinity)
        
        var body = Data()

        let boundary = UUID().uuidString
        
        [UploadFile("file", image.kf.jpegRepresentation(compressionQuality: 1.0)!, "multipart/form-data")].forEach { file in
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.name)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        if let formData = formData {
            formData.forEach { key, value in
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value ?? "null")\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        
        request.addValue("Bearer \(access_token!)", forHTTPHeaderField: "Authorization")
        
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            let model = try! JSONDecoder().decode(RequestForUploadImage.self, from: data)
            print(model)
            
             self.addPhotoPost(id: model.id!, name: model.name!, namePost: namePost, description: description)
        }
        let queue = DispatchQueue.global(qos: .background)
        queue.async{
            
            task.resume()
        }
        
    }
    
    func addPhotoPost(id: Int, name: String, namePost: String, description: String) {
        print("id: \(id)")
        print(name)
        let parameters = [
                "name":"\(namePost)",
                "dateCreate": "2020-03-04T06:35:47.861Z",
                "description": "\(description)",
                "new": true,
                "popular": true,
                "image": "/api/media_objects/\(id)"
                ] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        let access_token = UserDefaults.standard.string(forKey: "access_token")
        let postData = jsonData
        var request = URLRequest(url: URL(string: "http://gallery.dev.webant.ru/api/photos")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(access_token!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }
        let queue = DispatchQueue.global(qos: .background)
        queue.async{
        task.resume()
        }
    }
    
}

//class ExtendedApiRequest<T: Codable> : ApiRequest<T> {
//
//    override public init(_ endpoint: ApiEndpoint) {
//        super.init(endpoint)
//        super.responseTimeout = 30
//    }
//
//    override var request: URLRequest {
//        var result = super.request
//        result.timeoutInterval = self.responseTimeout
//        return result
//    }
//
//    static public func extendedRequest<T: Codable>(
//            path: String? = nil,
//            method: HttpMethod,
//            endpoint: ApiEndpoint = ApiEndpoint.baseEndpoint,
//            headers: [Header]? = nil,
//            formData: FormDataFields? = nil,
//            files: [UploadFile]? = nil,
//            body: BodyConvertible? = nil,
//            query: QueryField...) -> ExtendedApiRequest<T> {
//        let request = ExtendedApiRequest<T>(endpoint)
//        request.path = path
//        request.method = method
//        request.headers = headers
//        request.formData = formData
//        request.files = files
//        request.body = body
//        request.query = query
//        return request
//    }
//}
//
//
/////oauth/v2/token?client_id=&grant_type=refresh_token&refresh_token=&client_secret=
//extension ExtendedApiRequest {
//    static func addChunk(chunkHeaderId: Int, offset: Int, size: Int, file: Data) -> ExtendedApiRequest {
//        let uploadFile = UploadFile("file", file, "multipart/form-data")
////        return extendedRequest(method: .post, endpoint: ApiEndpoint("https://httpbin.org/post"), //)
//        return extendedRequest(path: "/chunks_headers/\(chunkHeaderId)/add-chunk",
//                method: .post,
////                headers: [Header("Content-Type", "multipart/form-data")],
//                files: [uploadFile],
//                query: ("offset", String(offset)),
//                ("size", String(size)))
//    }
//}

public struct UploadFile {

    public let name: String
    public let data: Data
    public let mimeType: String


    public init(_ name: String, _ data: Data, _ mimeType: String) {
        self.name = name
        self.data = data
        self.mimeType = mimeType
    }
}
