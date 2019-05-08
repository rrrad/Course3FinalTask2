//
//  ListViewModelDataPrepare.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 16/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

class ListViewModelDataPrepare {
    
    private var networkManager = NetworkManager()
    private var requestManager = RequestManager()
    
    var dataForViewModel: (([UserModel]?, Eerr) -> Void)?
    
    private var id: String?
    private var type: ListViewType
    
    init(id: String?, type: ListViewType) {
        self.id = id
        self.type = type
    }
    
    func getData(){
        if let id = id {
            let req: URLRequest?
            switch type{
            case .follover:
                req = requestManager.userFollowers(idUser: id)
            case .folloving:
                req = requestManager.userFollowing(idUser: id)
            case .like:
                req = requestManager.userLiked(idPost: id)
            }
            networkManager.fetch(request: req) { [weak self] (res) in
                switch res {
                    
                case .success(let resData):
                    guard let data = resData as? Data else {return}
                    let decoder = JSONDecoder()
                    do {
                        let users = try decoder.decode([UserModel].self, from: data)
                        if self?.dataForViewModel != nil {
                            self?.dataForViewModel!(users, .noerr)
                        }
                    } catch {
                        self?.dataForViewModel!(nil, .localerr)
                    }
                case .fail(let eerr):
                    self?.dataForViewModel!(nil, eerr)
                }
            }
        }
    }
}
