//
//  Routable.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 23/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation

protocol Routable: Presentable {
    var screenIsBlocked: Bool {get set}
    
    func presentModule(_ module: Presentable?)
    
    func dismissModule(_ module: Presentable?)
    
    func setRootModule(_ module: Presentable)
    
    func removeRootModule()
    
    func showBlockScreen()
    
    func hideBlockScreen()
    
    func showAlert(title: String, dismissCurrentVC: Bool)
}
