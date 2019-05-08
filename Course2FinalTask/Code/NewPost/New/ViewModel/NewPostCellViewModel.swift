//
//  NewPostCellViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol NewPostCellViewModelProtocol {
    func getImage() -> UIImage?
}

class NewPostCellViewModel: NewPostCellViewModelProtocol {
    private var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
    }
    
    func getImage() -> UIImage? {
        return image
    }
}
