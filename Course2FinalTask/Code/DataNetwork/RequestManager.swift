//
//  RequestConfigurator.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 30/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

enum httpMethod: String {
    case post = "POST"
    case get = "GET"
}

class RequestManager: NSObject {
    private let scheme = "http"
    private let host = "localhost"
    private let port: NSNumber = 8080
    private let defaultHeders = [
        "Content-Type" : "application/json",
        "cache-control" : "no-cache"
    ]
    private var urlComponents: NSURLComponents = {
        let uc = NSURLComponents()
        uc.scheme = "http"
        uc.host = "localhost"
        uc.port = 8080
        return uc
    }()
    
   private func requestAdd(request: inout URLRequest, method: httpMethod, auth: Bool){
        switch method {
        case .post:
            request.httpMethod = httpMethod.post.rawValue
        case .get:
            request.httpMethod = httpMethod.get.rawValue
        }
        if auth {
            var headers = defaultHeders
            headers["token"] = AuthModel.token!
            request.allHTTPHeaderFields = headers

        } else {
            request.allHTTPHeaderFields = defaultHeders

        }
    }
    
    private func requestAddParametr(request: inout URLRequest, parameter: [String: String]) {
        let data = try? JSONSerialization.data(withJSONObject: parameter, options: [])
        request.httpBody = data
    }
    
    private func convertImage(image: UIImage) -> String? {
        guard let imageData = UIImagePNGRepresentation(image)?.base64EncodedData(),
            let imageString = String.init(data: imageData, encoding: .utf8) else { return nil }
        return imageString
    }
    
    //MARK: - Public metods
    
    public func loginRequest(log: String, pas: String) -> URLRequest? {
        urlComponents.path = "/signin"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAddParametr(request: &request,
                           parameter: ["login":log, "password":pas])

       requestAdd(request: &request,
                  method: .post,
                  auth: false)
        
        return request
    }
    
    public func loguot() -> URLRequest? {
        
        urlComponents.path = "/signout"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAdd(request: &request, method: .post, auth: true)
        return request
    }
    
    public func user(id: String?) -> URLRequest? {
        if id == nil {
            urlComponents.path = "/users/me"
        } else {
            urlComponents.path = "/users/" + id!
        }
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)

        requestAdd(request: &request, method: .get, auth: true)
        return request
    }
    
   public func userPosts(idUser: String?) -> URLRequest? {
        guard let id = idUser else {return nil}
        
        urlComponents.path = "/users/" + id + "/posts"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAdd(request: &request, method: .get, auth: true)

        return request
    }
    
    public func userLiked(idPost: String?) -> URLRequest? {
        guard let id = idPost else {return nil}
        
        urlComponents.path = "/posts/" + id + "/likes"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)

        requestAdd(request: &request, method: .get, auth: true)

        return request
    }
    
    public func userFollowers(idUser: String?) -> URLRequest? {
        guard let id = idUser else {return nil}
        
        urlComponents.path = "/users/" + id + "/followers"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAdd(request: &request, method: .get, auth: true)

        return request
    }
    
    public func userFollowing(idUser: String?) -> URLRequest? {
        guard let id = idUser else {return nil}
        
        urlComponents.path = "/users/" + id + "/following"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAdd(request: &request, method: .get, auth: true)

        return request
    }
    
    public func postsFeed() -> URLRequest? {
        
        urlComponents.path = "/posts/feed"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)

        requestAdd(request: &request, method: .get, auth: true)

        return request
    }
    
    public func postsLikeUnlike(like: Bool, id: String) -> URLRequest? {
        if like {
            urlComponents.path = "/posts/like"
        } else {
            urlComponents.path = "/posts/unlike"
        }
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAddParametr(request: &request, parameter: ["postID": id])
        requestAdd(request: &request, method: .post, auth: true)

        
        return request
    }
    
    public func userFollowUnfollow(follow: EnumFollowUnfollow, id: String) -> URLRequest? {
        switch follow {
        case .follow:
            urlComponents.path = "/users/follow"
        case .unfollow:
            urlComponents.path = "/users/unfollow"
        }
                
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAddParametr(request: &request, parameter: ["userID": id])
        requestAdd(request: &request, method: .post, auth: true)
        
        return request
    }
    
    public func create(description: String, image: UIImage) -> URLRequest? {
        
        guard let image = convertImage(image: image) else {return nil}
        
        urlComponents.path = "/posts/create"
        
        guard let url = urlComponents.url else {return nil}
        var request = URLRequest.init(url: url)
        
        requestAddParametr(request: &request, parameter: ["description": description, "image": image])
        requestAdd(request: &request, method: .post, auth: true)
        
        return request
    }
    
}
