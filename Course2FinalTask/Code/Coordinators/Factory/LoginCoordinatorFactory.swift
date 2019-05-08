//
//  LoginCoordinatorFactory.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 02/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation

protocol LoginCoordinatorFactoryProtocol  {
    func makeFirstViewController() -> Presentable & LoginViewControllerOutputProtocol
}

class LoginCoordinatorFactory: LoginCoordinatorFactoryProtocol {
    func makeFirstViewController() -> Presentable & LoginViewControllerOutputProtocol {
        return LoginViewController()
    }
    
    
}
