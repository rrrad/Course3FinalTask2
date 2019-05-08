//
//  Router.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 23/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

final class Router: NSObject, Routable {
    
    private var rootController: UIViewController?
    private var activity: ActivityIndicator?
    var screenIsBlocked: Bool = false
    
    init(_ root: UIViewController) {
        rootController = root
    }
    
    func presentModule(_ module: Presentable?) {
        guard let controller = module?.toPresent else { return }
        rootController?.present(controller, animated: true, completion: nil)
    }
    
    func dismissModule(_ module: Presentable?) {
        rootController?.dismiss(animated: true, completion: nil)
    }
    
    func setRootModule(_ module: Presentable) {
        let vc = module.toPresent
        
        if let child = rootController?.childViewControllers, child.count > 0 {
            child[0].willMove(toParentViewController: nil)
            child[0].view.removeFromSuperview()
            child[0].removeFromParentViewController()
        }
        rootController?.addChildViewController(module.toPresent!)
        rootController?.view.addSubview(module.toPresent!.view)
        vc!.view.frame = rootController!.view.bounds
        vc!.didMove(toParentViewController: rootController)
    }
    
    func removeRootModule() {
        if let child = rootController?.childViewControllers, child.count > 0 {
            
            child[0].willMove(toParentViewController: nil)
            child[0].view.removeFromSuperview()
            child[0].removeFromParentViewController()
        }
    }
    
    func showBlockScreen() {
        if rootController != nil, !screenIsBlocked {
            DispatchQueue.main.async { [weak self] in
                self?.activity = ActivityIndicator()
                self?.rootController!.view.addSubview(self!.activity!)
                self?.screenIsBlocked = true
            }
        }
    }
    
    func hideBlockScreen() {
        if rootController != nil {
            DispatchQueue.main.async { [weak self] in
                self?.activity?.removeFromSuperview()
                self?.screenIsBlocked = false
            }
            
        }
    }
    
    func showAlert(title: String, dismissCurrentVC: Bool) { //надо ввести индекс делать возврат
                                    //на предыдущий контроллер или нет
                                    //это для DescribePostController
        let alert = UIAlertController(title: title,
                                      message: "Please try again later",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "OK", style: .cancel) { [weak rootController](res) in
            if dismissCurrentVC {
                DispatchQueue.main.async {
                    if let tab = rootController?.childViewControllers[0] as? UITabBarController {
                        if let nav = tab.selectedViewController as? UINavigationController{
                            nav.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        alert.addAction(action)
        rootController?.present(alert, animated: true, completion: nil)
    }
    
    var toPresent: UIViewController? {
        return rootController
    }

}
