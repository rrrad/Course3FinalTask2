//
//  Presentable.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 23/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

protocol Presentable {
    var toPresent: UIViewController? {get}
}

extension UIViewController: Presentable {
    var toPresent: UIViewController? {
        return self
    }
}
