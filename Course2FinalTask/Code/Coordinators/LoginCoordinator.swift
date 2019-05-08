//
//  LoginCoordinator.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 24/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

class LoginCoordinator: CoordinatorOutputProtocol {
   
    var callBack: ((Eerr, Bool) -> Void)?
    var finalBlock: (() -> Void)?
    
    var router: Routable
    
    fileprivate var name: String
    fileprivate var factory: LoginCoordinatorFactoryProtocol
    
    init(name: String, root: UIViewController) {
        self.name = name
        router = Router.init(root)
        factory = LoginCoordinatorFactory()
    }
}

extension LoginCoordinator: Coordinable {
    var nameCoordinator: String {
        return name
    }
    
    func start()  {
        loginScreen()
    }
}


private extension LoginCoordinator {
    func loginScreen(){
        var vc = factory.makeFirstViewController()
        vc.callBack = {[weak self] (eerr, block) in
            switch eerr {
            case .noerr:
                self?.router.hideBlockScreen()
                self?.router.removeRootModule()
                self?.finalBlock!()
            case .submit:
                self?.router.showBlockScreen()
            default:
                self?.router.hideBlockScreen()
                self?.router.showAlert(title: eerr.rawValue, dismissCurrentVC: true)
            }
        }
        router.setRootModule(vc)
    }
}
