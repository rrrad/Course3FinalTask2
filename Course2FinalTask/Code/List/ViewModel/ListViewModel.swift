//
//  ListViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 09/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol ListViewModelProtocol {
    var dataIsReady: dataIsReady {get set}
    func setData()
    
    var name: String {set get}
    func countItem() -> Int
    func getAvatar(for indexPath: IndexPath) -> URL?
    func getFullName(for indexPath: IndexPath) -> String
    func getProfileViewModel(at index: IndexPath) -> ProfileViewModelProtocol
}


enum ListViewType: String {
    case follover = "Follover"
    case folloving = "Folloving"
    case like = "Like"
}

class ListViewModel: ListViewModelProtocol {
    
    var dataIsReady: dataIsReady
    
    var name: String
    
    private var arrayData: [UserModel] = []
    private var dataManager: ListViewModelDataPrepare
    
    init(id: String?, typelist: ListViewType) {
        dataManager = ListViewModelDataPrepare.init(id: id, type: typelist)
        name = typelist.rawValue
    }
    
    func setData() {
        dataManager.getData()
        dataManager.dataForViewModel = { [weak self] (users, eerr) in
            if users != nil {
                self?.arrayData = users!
                if self?.dataIsReady != nil {
                    self?.dataIsReady!(.noerr)
                }
            } else {
                if self?.dataIsReady != nil {
                    self?.dataIsReady!(eerr)
                }
            }
            
        }
    }
    
    func countItem() -> Int {
        return arrayData.count
    }
    
    func getAvatar(for indexPath: IndexPath) -> URL? {
        guard let url = URL.init(string: arrayData[indexPath.row].avatar) else {return nil}
        return url
    }
    
    func getFullName(for indexPath: IndexPath) -> String {
        return arrayData[indexPath.row].fullName
    }
    
    func getProfileViewModel(at index: IndexPath) -> ProfileViewModelProtocol {
        let vm = ProfileViewModel.init(id: arrayData[index.row].id)
        return vm
    }
}
