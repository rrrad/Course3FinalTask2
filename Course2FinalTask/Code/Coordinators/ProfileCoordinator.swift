//
//  ProfileCoordinator.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 03/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

final class ProfileCoordinator: CoordinatorOutputProtocol{
    
    var finalBlock: (() -> Void)?
    var callBack: ((Eerr, Bool) -> Void)? //колбек вызывает активити индикатор если его нет либо убирает если он вызван

    var kfError : kfErrorsHandler // обработчик Kf err
    var router: Routable
    fileprivate var name: String
    fileprivate var factory: ProfileCoordinatorFactoryProtocol
    
    init(name: String, root: UINavigationController) {
        self.name = name
        self.router = RouterForNavigation.init(root)
        self.factory = ProfileCoordinatorFactory()
        self.kfError = kfErrorsHandler()
        kfError.callAction = {[weak self] (title) in
            self?.router.showAlert(title: title, dismissCurrentVC: false)
        }
    }
}

extension ProfileCoordinator: Coordinable{
    var nameCoordinator: String {
        return name
    }
    
    func start() {
        showProfile(nil)
    }
}

private extension ProfileCoordinator{
    func showProfile(_ viewModel: ProfileViewModelProtocol?) {
        
        var vc = factory.makeFirstViewController()
        
        if viewModel == nil {
            vc.setViewModel(ProfileViewModel.init(id: nil))
            router.setRootModule(vc)
            vc.logOut = {[weak self] in
                if self?.finalBlock != nil {
                    self?.finalBlock!()
                }
            }
        } else {
            vc.setViewModel(viewModel!)
            router.presentModule(vc)
        }
        
        
        
        vc.onClick = {[weak self] vm in
            if vm != nil {
                self?.showList(viewModel: vm!)
            }
        }
        
        vc.callBack = { [weak self] (err, block) in
            if self?.callBack != nil {
                self?.callBack!(err, block) // alert
            }
        }
        
        vc.kfErrorhandler = kfError
        
    }
    
    func showList(viewModel: ListViewModelProtocol) {
        var vc = factory.makeListViewController()
        vc.setViewModel(viewModel)
        vc.onClickCell = { [weak self] vm in
            self?.showProfile(vm)
        }
        vc.callBack = { [weak self] (err, block) in
            if self?.callBack != nil {
                self?.callBack!(err, block)
            }
        }
        vc.kfErrorhandler = kfError
        router.presentModule(vc)
    }
}
