//
//  ViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 22/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol NewPostViewModelProtocol {
    func countItem() -> Int
    func getNewPostCellViewModel(for index: Int) -> NewPostCellViewModelProtocol
    func setDataViewModel()
    func qetImage(_ index: Int) -> UIImage
}

class NewPostViewModel: NewPostViewModelProtocol {
    
    private var arrayData = [UIImage]()
    
    func countItem() -> Int {
        return arrayData.count
    }
    
    func getNewPostCellViewModel(for index: Int) -> NewPostCellViewModelProtocol {
        let vm = NewPostCellViewModel(image: arrayData[index])
        return vm
    }
    
    func setDataViewModel() {
        if arrayData.count == 0 { // это заглушка чтобы не перегружать изображения
            let arrayUrlPhoto = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "new.bundle")!
            
            for item in arrayUrlPhoto {
                let str = item.path
                if let im = UIImage.init(contentsOfFile: str) {
                    arrayData.append(im)
                }
                
            }
        }
    }
    
    func qetImage(_ index: Int) -> UIImage {
        return arrayData[index]
    }

}
