//
//  FeedPostCellViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 11/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

class FeedPostCellViewModel: FeedPostCellViewModelProtocol {
    
    private var discription: String?
    
    init(text: String?) {
        discription = text
    }
    
    func getDiscription() -> String? {
        return discription
    }
}
