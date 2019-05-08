//
//  FeedViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 11/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
import Kingfisher


protocol FeedViewModelProtocol {
    var dataIsReady: dataIsReady {get set}
    func setData()
    
    func countItems() -> Int // не забыть в вьюмодели умножить на 2
    func getCellViewModel(for index: Int) -> FeedCellViewModelProtocol
    func getPostCell(for index: Int) -> FeedPostCellViewModelProtocol
    func getText(for index: Int) -> String?
    
    func getListViewModel(for index: Int) -> ListViewModelProtocol
    func getProfileViewModel(for index: Int) -> ProfileViewModelProtocol
}



class FeedViewModel: FeedViewModelProtocol {
    
    private var networkManager = NetworkManager()
    private var requestManager = RequestManager()
    
    var dataIsReady: ((Eerr) -> Void)?
    
    private var arrayData: [PostModel] = []
    
    init() {

    }
    
    func setData() {
        let req = requestManager.postsFeed()
        networkManager.fetch(request: req) { [weak self] (res) in
            switch res {
                
            case .success(let resData):
                guard let data = resData as? Data else {return}
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    self?.arrayData = try decoder.decode([PostModel].self, from: data)
                    // запускаем префетч изображений в кеш
                    self?.prefetchImage()
                    
                    if self?.dataIsReady != nil {
                        self?.dataIsReady!(.noerr)
                    }
                } catch {
                    self?.dataIsReady!(.localerr)
                }
            case .fail(let eerr):
                self?.dataIsReady!(eerr)

            }
        }
    }
    
    func prefetchImage()  {
        // пробегаем по массиву и добавляем урл в Префетчер
        var urls = [URL]()
        for item in arrayData{
            if let urlAvatar = URL.init(string: item.authorAvatar) {
                urls.append(urlAvatar)
            }
            if let urlImage = URL.init(string: item.image) {
                urls.append(urlImage)
            }
        }
        
        let prefether = ImagePrefetcher.init(urls: urls)
        prefether.start()
    }
    
    func countItems() -> Int {
        return arrayData.count * 2
    }
    
    func getCellViewModel(for index: Int) -> FeedCellViewModelProtocol {
        let vm = FeedCellViewModel.init(index: index, post: arrayData[index])
        vm.onClikLike = {[weak self](index) in
            self?.clicLike(index)
        }

        return vm
    }
    
    func getPostCell(for index: Int) -> FeedPostCellViewModelProtocol {
        let vm = FeedPostCellViewModel.init(text: arrayData[index].description)
        return vm
    }
    
    func getText(for index: Int) -> String? {
        return arrayData[index].description
    }
    
    func clicLike(_ index: Int) -> (count: Int, like: Bool)?{
        let idPost = arrayData[index].id
        
        if arrayData[index].currentUserLikesThisPost{
            let req = requestManager.postsLikeUnlike(like: false, id: idPost)
            networkManager.fetch(request: req) { [weak self] (res) in
                switch res {
                    
                case .success(_): break
            
                case .fail(_):
                    self?.arrayData[index].likedByCount += 1
                    self?.arrayData[index].currentUserLikesThisPost = true
                    
                    // обновить вью после изменения ??
                    
                }
            }
            
            arrayData[index].likedByCount -= 1
            arrayData[index].currentUserLikesThisPost = false

            return (arrayData[index].likedByCount, arrayData[index].currentUserLikesThisPost)
        } else {
            let req = requestManager.postsLikeUnlike(like: true, id: idPost)
            networkManager.fetch(request: req) { [weak self] (res) in
                switch res {
                    
                case .success(_): break
            
                case .fail(_):
                    self?.arrayData[index].likedByCount -= 1
                    self?.arrayData[index].currentUserLikesThisPost = false
                    
                    // обновить вью после изменения ??
                    
                }
            }
            arrayData[index].likedByCount += 1
            arrayData[index].currentUserLikesThisPost = true

            return (arrayData[index].likedByCount, arrayData[index].currentUserLikesThisPost)
        }
    }
    
    func getListViewModel(for index: Int) -> ListViewModelProtocol {
        let vm = ListViewModel.init(id: arrayData[index].id, typelist: .like)
        return vm
    }
    
    func getProfileViewModel(for index: Int) -> ProfileViewModelProtocol {
        let vm = ProfileViewModel.init(id: arrayData[index].author)
        return vm
    }
    
}
