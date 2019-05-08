//
//  MainCoordinatorFactory.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 24/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

protocol MainCoordinatorFactoryProtocol {
    func makeViewControllers() -> [UINavigationController]
    func makeCoordinators(_ controllers: [UINavigationController]) -> [Coordinable & CoordinatorOutputProtocol]
}

class MainCoordinatorFactory: MainCoordinatorFactoryProtocol {
    
    func makeViewControllers() -> [UINavigationController] {
        
        let vc1 = UIViewController()
        let nav1 = UINavigationController.init(rootViewController: vc1)
        nav1.tabBarItem.title = "Feed"
        nav1.tabBarItem.image = UIImage.init(named: "feed")
        
            
        let vcn = UIViewController()
        let navn = UINavigationController.init(rootViewController: vcn)
        navn.tabBarItem.title = "New"
        navn.tabBarItem.image = UIImage.init(named: "plus")
        
        let vc2 = UIViewController()
        let nav2 = UINavigationController.init(rootViewController: vc2)
        nav2.tabBarItem.title = "Profile"
        nav2.tabBarItem.image = UIImage.init(named: "profile")
        
        return [nav1, navn, nav2]
    }
    
    func makeCoordinators(_ controllers: [UINavigationController]) -> [Coordinable & CoordinatorOutputProtocol] {
        if controllers.count != 3 {
            return []
        } else {
        let coordinator1 = FeedCoordinator.init(name: "Feed", root: controllers[0])
        let coordinator2 = NewPostCoordinator.init(name: "New", root: controllers[1])
        let coordinator3 = ProfileCoordinator.init(name: "Profile", root: controllers[2])
            return [coordinator1, coordinator2, coordinator3]
        }
    }
    
}
