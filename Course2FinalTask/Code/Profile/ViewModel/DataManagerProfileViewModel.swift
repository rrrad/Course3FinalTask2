//
//  DataPrepareProfileViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 16/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation


protocol DataManagerProfileViewModelProtocol {
    var uid: String? {get}
    var dataForViewModel: (([PostModel]?, UserModel?, Eerr) -> Void)? {get set}
    func getData()
    func followUnfollow(_ action: EnumFollowUnfollow)
    func logOut()
}


class DataManagerProfileViewModel: DataManagerProfileViewModelProtocol{
    
    let networkManager = NetworkManager()
    let requestManager = RequestManager()
    
    var dataForViewModel: (([PostModel]?, UserModel?, Eerr) -> Void)?
    
    var uid: String?
    private var posts = [PostModel]()
    private var user: UserModel? {
        didSet {
            requestPosts(id: user?.id)
        }
    }

    
    
    init(id: String?) {
        self.uid = id
        if CurrenrUserIDModel.id == nil {
            
            let req = requestManager.user(id: nil)
            networkManager.fetch(request: req) { res in
                switch res {
                    
                case .success(let resData):
                    guard let data = resData as? Data else {return}
                    do {
                        let json = try JSONSerialization.jsonObject(with: data,
                                                                    options: [])
                                                                as? [String : Any]
                        CurrenrUserIDModel.id = json!["id"] as? String
                    } catch {
                       
                    }
                case .fail(_): break

                }
            }
        }
    }
    
    func getData() {
        let req = requestManager.user(id: uid)
        networkManager.fetch(request: req) { [weak self] res in
            switch res {
                
            case .success(let resData):
                guard let data = resData as? Data else {return}
                let decoder = JSONDecoder()
                do {
                    self?.user = try decoder.decode(UserModel.self, from: data)
                } catch {
                    self?.dataForViewModel!(self?.posts, self?.user, .localerr)
                }
            case .fail(let eerr):
                self?.dataForViewModel!(self?.posts, self?.user, eerr)

            }
        }
    }
    
    func requestPosts(id: String?) {
        let req = requestManager.userPosts(idUser: user?.id)
        networkManager.fetch(request: req) { [weak self] res in
            switch res {
                
            case .success(let resData):
                guard let data = resData as? Data else {return}
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    self?.posts = try decoder.decode([PostModel].self, from: data)
                    self?.dataForViewModel!(self?.posts, self?.user, .noerr)
                } catch {
                    self?.dataForViewModel!(self?.posts, self?.user, .localerr)
                }
            case .fail(let eerr):
                self?.dataForViewModel!(self?.posts, self?.user, eerr)
            }
        }
    }
    
    func followUnfollow(_ action: EnumFollowUnfollow) {
        
        let req = requestManager.userFollowUnfollow(follow: action, id: user!.id)
            networkManager.fetch(request: req) { (res) in
                // если ошибка как - то вернуть UI
            }
        
    }
    
    func logOut() {
        let req = requestManager.loguot()
        networkManager.fetch(request: req) {_ in 
            AuthModel.token = nil
        }
    }
}
