//
//  ProfileCoordinatorFactory.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 08/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation

protocol ProfileCoordinatorFactoryProtocol {
    func makeFirstViewController() -> Presentable & ProfileViewControllerOutputProtocol & ProfileViewControllerInputProtocol
    func makeListViewController() -> Presentable & ListViewControllerOutputProtocol & ListViewControllerInputProtocol
    
}

class ProfileCoordinatorFactory: ProfileCoordinatorFactoryProtocol {
    func makeFirstViewController() -> Presentable & ProfileViewControllerOutputProtocol & ProfileViewControllerInputProtocol {
        return ProfilViewController.init(someData: "Profile")
    }
    
    func makeListViewController() -> Presentable & ListViewControllerOutputProtocol & ListViewControllerInputProtocol {
        return ListViewController.init(someData: "List")
    }
}
