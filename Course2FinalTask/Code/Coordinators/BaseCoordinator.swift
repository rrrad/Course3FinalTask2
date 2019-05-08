//
//  BaseCoordinator.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 24/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation

class BaseCoordinator {
    var childCoordinators: [String : Coordinable] = [:]
    
    func addDependency(_ coordinator: Coordinable) {
        if childCoordinators[coordinator.nameCoordinator] != nil { return }
        childCoordinators[coordinator.nameCoordinator] = coordinator
    }
    
    func removeDependecy(_ coordinator: Coordinable?) {
        guard childCoordinators.isEmpty == false, let coord = coordinator else {return}
        childCoordinators.removeValue(forKey: coord.nameCoordinator)
        }
    
    func removeAllDependency() {
        guard childCoordinators.isEmpty == false else {return}
        childCoordinators.forEach { (item) in
            item.value.router.removeRootModule()
        }
        childCoordinators.removeAll()
    }
}

