//
//  KfErrorsHandler.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 12/04/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation
protocol ErrorsHandlerProtocol {
    var callAction: ((_ title: String) -> Void)? {get set}
    func recevedError(_ codErr: Int)
}

class kfErrorsHandler: ErrorsHandlerProtocol {
    var callAction: ((String) -> Void)?
    
    func recevedError(_ codErr: Int) {
        if callAction != nil, codErr != 5002 {
            callAction!("Unknown error")
        }
    }
}
