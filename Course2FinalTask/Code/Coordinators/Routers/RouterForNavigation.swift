//
//  RouterForNavigation.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 03/03/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

final class RouterForNavigation: NSObject, Routable{
    
    
    private var rootController: UINavigationController?
    
    var screenIsBlocked: Bool = false
    var alertIsShow: Bool = false

    
    init(_ root: UINavigationController ) {
        super.init()
        self.rootController = root
    }
    
    
    func presentModule(_ module: Presentable?) {
        guard let controller = module?.toPresent else { return }
        if rootController != nil {
            rootController!.pushViewController(controller, animated: true)
        }
    }
    
    func dismissModule(_ module: Presentable?) {
        if rootController != nil {
            rootController!.popViewController(animated: true)
        }
    }
    
    func setRootModule(_ module: Presentable) {
        guard let controller = module.toPresent else { return }
        rootController?.setViewControllers([controller], animated: false)
    }
    
    func removeRootModule() {
        rootController = nil
    }
    
    func showBlockScreen() {
        
    }
    
    func hideBlockScreen() {
        
    }
    
    func showAlert(title: String, dismissCurrentVC: Bool) {
        if alertIsShow == false{
        let alert = UIAlertController(title: title,
                                      message: "Please try again later",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "OK", style: .cancel){ [weak self] (_) in
            self?.alertIsShow = false
            }
        alert.addAction(action)
        rootController!.visibleViewController!.present(alert, animated: true, completion: nil)
            alertIsShow = true
        }
    }
    
    var toPresent: UIViewController? {
        return rootController
    }
    
}
