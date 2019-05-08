//
//  MainTabBarCoordinator.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 02/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

class MainTabBarCoordinator: BaseCoordinator, CoordinatorOutputProtocol {
    
    var callBack: ((Eerr, Bool) -> Void)?
    var finalBlock: (() -> Void)?
    
    fileprivate var name: String
    var router: Routable
    fileprivate var controllers: [UINavigationController]
    fileprivate var factory: MainCoordinatorFactoryProtocol
    
    fileprivate var tabBar: UITabBarController?
    
    init(name: String, root: UIViewController) {
        self.name = name
        router = Router(root)
        factory = MainCoordinatorFactory()
        controllers = factory.makeViewControllers()
        super.init()
        
        setCoordinators(factory.makeCoordinators(controllers))
        
        tabBar = UITabBarController.init()
        tabBar!.viewControllers = controllers
    }
}

extension MainTabBarCoordinator: Coordinable {
    var nameCoordinator: String {
        return name
    }
    
    func start() {
        router.setRootModule(tabBar!)
    }
}


private extension MainTabBarCoordinator {
    func setCoordinators(_ coordinators: [Coordinable & CoordinatorOutputProtocol]) {
        coordinators.forEach {[unowned self](data) in
            var coord = data
            self.addDependency(coord)
            coord.finalBlock = {[weak self] in
                self?.removeAllDependency()
                self?.router.removeRootModule()

                if self?.finalBlock != nil {
                    self?.finalBlock!()
                }
            }
            coord.callBack = {[weak self, weak coord](err, block) in
                var dismiss = true
                if coord as? NewPostCoordinator != nil {
                    dismiss = false
                    if err == .noerr {
                        DispatchQueue.main.async {
                            self?.tabBar?.selectedIndex = 0
                            if let nav = self?.tabBar?.selectedViewController as? UINavigationController,
                                var vc = nav.viewControllers[0] as? FeedViewControllerInputProtocol {
                                vc.scrollToTop = true // если переход на ленту отсюда(новый пост) скролим наверх ленту
                                nav.popToRootViewController(animated: true)
                                
                            }
                        }
                    }
                }
                
                if block {
                    self?.router.showBlockScreen()
                } else {
                    self?.router.hideBlockScreen()
                    if err == Eerr.noerr || err == Eerr.submit  {
                        
                    } else {
                        DispatchQueue.main.async {[weak self] in
                            self?.router.showAlert(title: err.rawValue, dismissCurrentVC: dismiss)
                        }
                    }
                }
            }
            coord.start()
        }
    }
}



