//
//  DescriptionPostViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 24/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol DescriptionPostViewModelProtocol {
    var dataIsReady: dataIsReady {get set}
    func getImage() -> UIImage?
    func share(text: String?)
}

class DescriptionPostViewModel: DescriptionPostViewModelProtocol {
    
    private var networkManager = NetworkManager()
    private var requestManager = RequestManager()
   
    var dataIsReady: dataIsReady
    private var image: UIImage?
    
    init(_ image: UIImage?) {
        self.image = image
    }
    func getImage() -> UIImage? {
        return image
    }
    
    func share(text: String?) {
        if let im = image, let desc = text {
            let req = requestManager.create(description: desc, image: im)
            networkManager.fetch(request: req) { [weak self] (res) in
                switch res {
                    
                case .success(_):
                    if self?.dataIsReady != nil {
                        self?.dataIsReady!(.noerr)
                    }
                   
                case .fail(let eerr):
                    if self?.dataIsReady != nil {
                        self?.dataIsReady!(eerr)
                    }
                }
            }
        }
    }
}
