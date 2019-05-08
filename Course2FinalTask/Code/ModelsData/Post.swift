//
//  Post.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 03/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

struct PostModel: Codable {
    var id: String
    var author: String
    var description: String
    var image: String
    var currentUserLikesThisPost: Bool
    var createdTime: Date
    var likedByCount: Int
    var authorUsername: String
    var authorAvatar: String
}
