//
//  ProfileImageCellViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 10/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol ProfileImageCellViewModelProtocol {
    func getImage() -> URL?
}

class ProfileImageCellViewModel: ProfileImageCellViewModelProtocol {
    private var imageUrl: URL?
    init(image: String?) {
        if image != nil{
            self.imageUrl = URL.init(string: image!)

        }
    }
    func getImage() -> URL? {
        return imageUrl
    }
}
