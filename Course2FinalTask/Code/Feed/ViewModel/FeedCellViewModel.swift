//
//  FeedCellViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 11/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol FeedCellViewModelProtocol {
    
    func getAvatar() -> URL?
    func getName() -> String?
    func getFormatedDate() -> String?
    func getPostImage() -> URL?
    func getLike() -> (count:Int, like: Bool)?
    
    var onClikLike: ((_: Int) -> (count: Int, like: Bool)?)? {set get}
    var onClikCellProfile: (() -> Void)? {set get}
    var onClikCellCountLike: (() -> Void)? {set get}
    
    func clicLike()
    
}

class  FeedCellViewModel: FeedCellViewModelProtocol {
    
    private var index: Int
    
    private var avatar: URL?
    private var name: String?
    private var date: String?
    private var postImage: URL?
    private var countLike: Int?
    private var liked: Bool?
    
    var onClikLike: ((_: Int) -> (count: Int, like: Bool)?)?
    var onClikCellProfile: (() -> Void)?
    var onClikCellCountLike: (() -> Void)?


    init(index: Int, post: PostModel ){
        self.index = index
        self.avatar = URL.init(string: post.authorAvatar)
        self.name = post.authorUsername
        self.postImage = URL.init(string: post.image)
        self.countLike = post.likedByCount
        self.liked = post.currentUserLikesThisPost
        
        self.date = formattDate(from: post.createdTime)
    }
    
    func formattDate (from date: Date?) -> String?{
        if let d = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            return formatter.string(from:d)
        } else {
            return nil
        }
    }
    
    
    func getAvatar() -> URL? {
        return avatar
    }
    
    func getName() -> String? {
        return name
    }
    
    func getFormatedDate() -> String? {
        return date
    }
    
    func getPostImage() -> URL? {
        return postImage
    }
    
    func getLike() -> (count: Int, like: Bool)? {
        if countLike != nil, liked != nil {
            return (countLike!, liked!)
        } else {
            return nil
        }
    }
    
    func clicLike() {
        guard let clik = onClikLike?(index) else { return }
        countLike = clik.count
        liked = clik.like
    }
    
}
