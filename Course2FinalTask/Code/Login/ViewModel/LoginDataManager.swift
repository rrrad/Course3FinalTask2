//
//  LoginDataManager.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 30/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
class LoginDataManager {
    let requestManager = RequestManager()
    let networkManager = NetworkManager()
    
    var LogIn: ((Eerr) -> Void)?
    
    func sendRequest(login: String, password: String) {
        let req = requestManager.loginRequest(log: login, pas: password)
        networkManager.fetch(request: req) { [weak self] res in
            switch res{
                
            case .success(let resData):
                guard let data = resData as? Data else {return}
                do{
                    if let json = try JSONSerialization.jsonObject(with: data,
                                                                   options: [])
                        as? [String : String],
                        let token = json["token"]{
                        AuthModel.token = token
                        if self?.LogIn != nil {
                            self?.LogIn!(.noerr)
                        }
                    }
                } catch {
                    if self?.LogIn != nil {
                        self?.LogIn!(.localerr)
                    }
                }
            case .fail(let eerr):
                if self?.LogIn != nil {
                    self?.LogIn!(eerr)
                }
            }
        }
    }
}

