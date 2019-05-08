//
//  NewPostCoordinator.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 23/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

final class NewPostCoordinator: CoordinatorOutputProtocol{
    
    var finalBlock: (() -> Void)?
    var callBack: ((Eerr, Bool) -> Void)? //eerr ошибка если есть, bool показывать блокирующий экран или нет
    
    private var nav: UINavigationController
    var router: Routable
    fileprivate var name: String
    fileprivate var factory: NewPostCoordinatorFactoryProtocol
    
    init(name: String, root: UINavigationController) {
        self.nav = root
        self.name = name
        self.router = RouterForNavigation.init(root)
        self.factory = NewPostCoordinatorFactory()
    }
}

extension NewPostCoordinator: Coordinable{
    var nameCoordinator: String {
        return name
    }
    
    func start() {
        showChoisePhoto()
        
    }
}

private extension NewPostCoordinator{
    func showChoisePhoto() {
        var vc = factory.makeFirstViewController()
        vc.onClickPhoto = { [weak self] image in
            self?.choiсeFilter(image)
        }
        router.setRootModule(vc)
    }
        
    func choiсeFilter(_ image: UIImage) {
        var vc = factory.makeFilterViewController()
        vc.setViewModel(FilterViewModel.init(image: image))
        vc.callBack = { [weak self] (eerr, block) in
            self?.callBack!(eerr, block)
        }
        vc.onClickNext = { [weak self] image in
            self?.setDescription(image)
        }
        router.presentModule(vc)
    }
    
    func setDescription(_ image: UIImage?) {
        var vc = factory.makeDescribePostViewController()
        let vm = DescriptionPostViewModel.init(image)
        vc.setViewModel(vm)
        vc.onClickShare = {[weak self] (eerr, block) in
            if self?.callBack != nil {
                if eerr == .noerr {
                    DispatchQueue.main.async {
                        self?.nav.popToRootViewController(animated: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  }
                    }
                }
            self?.callBack!(eerr, block)
            }
        }
        router.presentModule(vc)
    }
        
}

