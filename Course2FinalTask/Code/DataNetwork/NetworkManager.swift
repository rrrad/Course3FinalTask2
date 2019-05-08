//
//  NetworkManager.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 30/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
enum Result<T>{
    case success(T)
    case fail(Eerr)
}

class NetworkManager: NSObject {
    
    lazy var defaultSession: URLSession = {
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 30
        conf.allowsCellularAccess = false
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let session = URLSession.init(configuration: conf,
                                      delegate: nil,
                                      delegateQueue: queue)
        return session
    }()
    
    func fetch(request: URLRequest?, ch: ((Result<Any>) -> Void)?){
        guard let req = request else { return }
        
        defaultSession.dataTask(with: req) { (d, r, e) in
            if let c = ch{
            if let r = r as? HTTPURLResponse, r.statusCode >= 300{
                switch r.statusCode{
                case 404:
                    c(.fail(.err404))
                case 400:
                    c(.fail(.err400))
                case 401:
                    c(.fail(.err401))
                case 406:
                    c(.fail(.err406))
                case 422:
                    c(.fail(.err422))
                default:
                    c(.fail(.err))
                }
            } else {
                if let data = d {
                    c(.success(data))
                }
            }
            
            if e != nil {
                c(.fail(.localerr))            }
            }
        }.resume()
    }
    
}


