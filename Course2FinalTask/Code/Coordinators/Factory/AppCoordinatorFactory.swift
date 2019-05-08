//
//  AppCoordinatorFactory.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 24/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

protocol AppCoordinatorFactoryProtocol {
    func makeLoginCoordinator() -> Coordinable & CoordinatorOutputProtocol
    
    func makeMainCoordinator() -> Coordinable & CoordinatorOutputProtocol
}

class AppCoordinatorFactory: AppCoordinatorFactoryProtocol {
    private var vc: UIViewController
    init(_ root: UIViewController) {
        vc = root
    }
    
    func makeMainCoordinator() -> Coordinable & CoordinatorOutputProtocol {
        return MainTabBarCoordinator.init(name: "main", root: vc)
    }
    
    func makeLoginCoordinator() -> Coordinable & CoordinatorOutputProtocol {
        return LoginCoordinator.init(name: "login", root: vc)
    }
    
    
    
}
