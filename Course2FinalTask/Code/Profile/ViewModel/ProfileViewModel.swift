//
//  ProfileViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 10/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation


protocol ProfileViewModelProtocol {
    var dataIsReady: dataIsReady {get set}
    func setData()
    func logOut()
    
    var name: String {get set}
    func countItems() -> Int
    func getImageCellViewModel(for indexPath: Int) -> ProfileImageCellViewModelProtocol
    func getCellViewModel() -> ProfileCellViewModelProtocol
    func getListViewModel(type: ListViewType) -> ListViewModelProtocol
}



class ProfileViewModel: ProfileViewModelProtocol {
    var dataIsReady: dataIsReady
    
    var name: String = ""
    private var arrayData: [PostModel] = []
    private var user: UserModel?
    
    private var dataManager: DataManagerProfileViewModelProtocol
    
    init(id: String?) {
        if id == nil {
            name = "Profile"
        }
        dataManager = DataManagerProfileViewModel(id: id)
    }
    
    func setData() {
        dataManager.getData()
        dataManager.dataForViewModel = {[weak self] (array, user, eerr) in
            if eerr == .noerr {
                self?.arrayData = array!
                self?.user = user!
                if self?.dataManager.uid != nil {self?.name = user!.username}
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
    
    func countItems() -> Int {
        return arrayData.count
    }
    
    func getImageCellViewModel(for index: Int) -> ProfileImageCellViewModelProtocol {
        let vm = ProfileImageCellViewModel.init(image: arrayData[index].image)
        return vm
    }
    
    func getCellViewModel() -> ProfileCellViewModelProtocol {
        let vm = ProfileCellViewModel.init(user: user)
        vm.followUnfollowCall = followUnfollowCallProvider
        return vm
    }
    
    func getListViewModel(type: ListViewType) -> ListViewModelProtocol {
        let vm = ListViewModel.init(id: user?.id, typelist: type)
        return vm
    }
    
    func followUnfollowCallProvider(_ action: EnumFollowUnfollow) {
        dataManager.followUnfollow(action)
    }
    
    func logOut() {
        dataManager.logOut()
    }
    
}
