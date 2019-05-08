//
//  FilterViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 23/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol FilterViewModelProtocol {
    func choise(index: Int, ch: @escaping (UIImage) -> Void)
    func getCountItem() -> Int
    func getImage() -> UIImage 
    func getCellViewModel(index: Int) -> FilterCellViewModelProtocol
}

class FilterViewModel: FilterViewModelProtocol {
    
    private let context = CIContext()
    private let size = CGSize.init(width: 150, height: 150)
    
    private var originalImage: UIImage
    private var tumbnailImage: UIImage?
    
    init(image: UIImage) {
        originalImage = image
        tumbnailImage = image.resize(size)
    }
        
    func getCellViewModel(index: Int) -> FilterCellViewModelProtocol {
        let op = FilterOperation.init(tumbnailImage!, name: typeFilter.allCases[index].rawValue, in: context)
        let vm = FilterCellViewModel.init(op)
        return vm
    }
    
    func getCountItem() -> Int {
       return typeFilter.allCases.count
    }
    
    func getImage() -> UIImage {
        return originalImage
    }
    
    func choise(index: Int, ch: @escaping (UIImage) -> Void) {
        
        let op = FilterOperation.init(originalImage,
                                      name: typeFilter.allCases[index].rawValue,
                                      in: context)
        op.completionBlock = {
            DispatchQueue.main.async {
                ch(op.outputImage!)
            }
        }
        
        DispatchQueue.global().async {
            op.start()
        }
    }
    
}

