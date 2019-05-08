//
//  AppCoordinator.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 24/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

fileprivate enum ScriptAppCoordinator{
    case authorization
    case main
}

final class AppCoordinator: BaseCoordinator {
    
    fileprivate var name: String
    var router: Routable
    fileprivate var factory: AppCoordinatorFactoryProtocol
    fileprivate var script: ScriptAppCoordinator = .authorization
    
    init(name: String, container: UIViewController) {
        self.name = name
        router = Router.init(container)
        factory = AppCoordinatorFactory(router.toPresent!)
        super.init()
    }
}

extension AppCoordinator: Coordinable {
    var nameCoordinator: String {
        return name
    }
    
    func start() {
        runScript()
    }
}

private extension AppCoordinator {
    func runScript(){
        switch script {
        case .authorization:
            performLoginflow()
        case .main:
            performMainFlow()
        }
    }
    

    func performLoginflow(){
        var coordinator = factory.makeLoginCoordinator()
        coordinator.finalBlock = {[unowned self, unowned coordinator] in
            self.removeDependecy(coordinator)
            self.script = .main
            self.runScript()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    func performMainFlow(){
        var coordinator = factory.makeMainCoordinator()
        coordinator.finalBlock = {[unowned self, unowned coordinator] in
            self.removeDependecy(coordinator)
            self.script = .authorization
            self.runScript()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
