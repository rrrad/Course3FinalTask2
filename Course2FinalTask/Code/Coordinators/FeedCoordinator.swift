//
//  FeedCoordinator.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 03/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit



final class FeedCoordinator: CoordinatorOutputProtocol{
    
    var finalBlock: (() -> Void)?
    var callBack: ((Eerr, Bool) -> Void)? //колбек вызывает активити индикатор 

    var kfError : kfErrorsHandler // обработчик Kf err
    var router: Routable
    fileprivate var name: String
    fileprivate var factory: FeedCoordinatorFactoryProtocol
    
    init(name: String, root: UINavigationController) {
        self.name = name
        self.router = RouterForNavigation(root)
        self.factory = FeedCoordinatorFactory()
        self.kfError = kfErrorsHandler()
        kfError.callAction = {[weak self] (title) in
            self?.router.showAlert(title: title, dismissCurrentVC: false)
        }
    }
}

extension FeedCoordinator: Coordinable{
    var nameCoordinator: String {
        return name
    }
    
    func start() {
        first()
    }
}

private extension FeedCoordinator{
    func first() {
        var vc = factory.makeFirstViewController()
        vc.setViewModel(FeedViewModel.init())
        vc.onClickProfile = {[weak self] vm in
            self?.showProfile(vm)
        }
        vc.onClickList = { [weak self] vm in
            self?.showList(vm)
        }
        vc.callBack = { [weak self] (err, block) in
            if self?.callBack != nil {
                self?.callBack!(err, block) // alert
            }
        }
        vc.kfErrorhandler = kfError
        router.setRootModule(vc)
    }
    
    func showProfile(_ viewModel: ProfileViewModelProtocol?) {
        var vc = factory.makeProfileViewController()
        vc.setViewModel(viewModel!)
        vc.onClick = {[weak self] vm in
            if vm != nil {
                self?.showList(vm!)
            }
        }
        vc.callBack = { [weak self] (err, block) in
            if self?.callBack != nil {
                self?.callBack!(err, block) //  alert
            }
        }
        vc.kfErrorhandler = kfError
        router.presentModule(vc)
    }
    
    func showList(_ viewModel: ListViewModelProtocol?) {
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
