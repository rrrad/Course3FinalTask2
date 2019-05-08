//
//  FeedCoordinatorFactory.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 08/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation

protocol FeedCoordinatorFactoryProtocol {
    func makeFirstViewController() -> Presentable & FeedViewControllerOutputProtocol & FeedViewControllerInputProtocol
    func makeListViewController() -> Presentable & ListViewControllerOutputProtocol & ListViewControllerInputProtocol
    func makeProfileViewController() -> Presentable & ProfileViewControllerOutputProtocol & ProfileViewControllerInputProtocol
}

class FeedCoordinatorFactory: FeedCoordinatorFactoryProtocol {
    func makeFirstViewController() -> Presentable & FeedViewControllerOutputProtocol & FeedViewControllerInputProtocol{
        return FeedViewController.init(someData: "Feed")
    }
    
    func makeListViewController() -> Presentable & ListViewControllerOutputProtocol & ListViewControllerInputProtocol{
        return ListViewController.init(someData: "List")
    }
    
    func makeProfileViewController() -> Presentable & ProfileViewControllerOutputProtocol & ProfileViewControllerInputProtocol {
        return ProfilViewController.init(someData: "Profile")
    }
}
