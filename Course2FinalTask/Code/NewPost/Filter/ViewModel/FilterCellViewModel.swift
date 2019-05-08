//
//  FilterCellViewModel.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 24/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol FilterCellViewModelProtocol {
    func getImageAfterFilter (_ ch: @escaping (UIImage?) -> Void)
    func getName() -> String
}

class FilterCellViewModel: FilterCellViewModelProtocol {
   
    private var operation: FilterOperation
    private var nameFilter: String
    
    init(_ operation: FilterOperation) {
        self.operation = operation
        self.nameFilter = operation.nameFilter!
    }
    
    func getName() -> String {
        return nameFilter
    }
    
    func getImageAfterFilter(_ ch: @escaping (UIImage?) -> Void) {
        operation.completionBlock = {[weak self] in
            ch(self?.operation.outputImage)
        }
        
        DispatchQueue.global().async {[weak self] in
            self?.operation.start()
        }
    }    
}
