//
//  ProfileCellViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 10/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol ProfileCellViewModelProtocol {
    func getAvatar() -> URL?
    func getFullName() -> String?
    func getFollowers() -> Int?
    func getFollowing() -> Int?
    func getCurrentUserFollow() -> Bool?
    
    var followUnfollowCall: ((EnumFollowUnfollow) -> Void)? {set get}
    
    func followUnfollow()
}

class ProfileCellViewModel: ProfileCellViewModelProtocol {
    private var avatar: URL?
    private var fullName: String?
    private var followers: Int?
    private var following: Int?
    private var currentUserFollow: Bool?
    
    var followUnfollowCall: ((EnumFollowUnfollow) -> Void)?
    
    init(user: UserModel?) {
        var cuf: Bool? = nil
        if user?.id != CurrenrUserIDModel.id {
            cuf = user?.currentUserFollowsThisUser
        }
        
        if user == nil {
            self.avatar = nil
        }
        else {
            self.avatar = URL.init(string: user!.avatar)
        }

        self.fullName = user?.fullName
        self.followers = user?.followedByCount
        self.following = user?.followsCount
        self.currentUserFollow = cuf
    }
    
    func getAvatar() -> URL? {
        return avatar
    }
    
    func getFullName() -> String? {
        return fullName
    }
    
    func getFollowers() -> Int? {
        return followers
    }
    
    func getFollowing() -> Int? {
        return following
    }
    
    func getCurrentUserFollow() -> Bool? {
        return currentUserFollow
    }

    func followUnfollow() {
        // здесь меняем данные для представления
        
        // отпрвляем запрос в VM  и PrepareData в последовательную очередь
        // очередь вероятно должна быть одна
        
        // получаем ответ и корректируем данные если надо
        
        if followUnfollowCall != nil {
            
            followUnfollowCall!(currentUserFollow! ? EnumFollowUnfollow.unfollow : EnumFollowUnfollow.follow)
        }
        
        if currentUserFollow! {
            currentUserFollow = false
            followers! -= 1
        } else {
            currentUserFollow = true
            followers! += 1
        }
        
    }

}
